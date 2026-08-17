--  SECTION 1: CREATE TABLES

CREATE TABLE LIBRARY (
    library_id   INT PRIMARY KEY AUTO_INCREMENT,
    name         VARCHAR(100) NOT NULL
);

-- Books table (maps to unordered_map<string, int> dictofBooks)
CREATE TABLE BOOKS (
    book_id          INT PRIMARY KEY AUTO_INCREMENT,
    library_id       INT NOT NULL,
    title            VARCHAR(200) NOT NULL UNIQUE,
    total_copies     INT DEFAULT 0,
    available_copies INT DEFAULT 0,
    FOREIGN KEY (library_id) REFERENCES LIBRARY(library_id)
);

-- Members / borrowers table
CREATE TABLE MEMBERS (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name      VARCHAR(100) NOT NULL
);

-- Donors table
CREATE TABLE DONORS (
    donor_id INT PRIMARY KEY AUTO_INCREMENT,
    name     VARCHAR(100) NOT NULL UNIQUE
);

-- Lend records (maps to unordered_map<string, vector<string>> LendRecord)
CREATE TABLE LEND_RECORDS (
    lend_id     INT PRIMARY KEY AUTO_INCREMENT,
    book_id     INT NOT NULL,
    member_id   INT NOT NULL,
    borrowed_on DATE DEFAULT (CURRENT_DATE),
    returned_on DATE,
    status      ENUM('active', 'returned') DEFAULT 'active',
    FOREIGN KEY (book_id)   REFERENCES BOOKS(book_id),
    FOREIGN KEY (member_id) REFERENCES MEMBERS(member_id)
);

-- Donation records (maps to unordered_map<string, vector<string>> DonorRecord)
CREATE TABLE DONATION_RECORDS (
    donation_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id     INT NOT NULL,
    donor_id    INT NOT NULL,
    donated_on  DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (book_id)  REFERENCES BOOKS(book_id),
    FOREIGN KEY (donor_id) REFERENCES DONORS(donor_id)
);


--  SECTION 2: SEED DATA — Insert library and sample books

INSERT INTO LIBRARY (name) VALUES ('BMS College Library');

INSERT INTO BOOKS (library_id, title, total_copies, available_copies) VALUES
    (1, 'The Alchemist',        3, 3),
    (1, 'Clean Code',           2, 2),
    (1, 'Data Structures in C', 4, 4);

INSERT INTO MEMBERS (name) VALUES
    ('Suyash'),
    ('Rahul'),
    ('Priya');

INSERT INTO DONORS (name) VALUES
    ('Rahul Sharma'),
    ('Anita Desai');

--  SECTION 3: DisplayBooks() — show all books and availability

SELECT
    title,
    total_copies,
    available_copies
FROM BOOKS
ORDER BY title;

--  SECTION 4: AddBooks() — add new or increment existing book

-- Adds 1 copy; if the book already exists, increments both counters
INSERT INTO BOOKS (library_id, title, total_copies, available_copies)
VALUES (1, 'The Pragmatic Programmer', 1, 1)
ON DUPLICATE KEY UPDATE
    total_copies     = total_copies + 1,
    available_copies = available_copies + 1;


--  SECTION 5: AddDonatedBook() — donate a book and record donor

-- Step 1: upsert the book (same as AddBooks)
INSERT INTO BOOKS (library_id, title, total_copies, available_copies)
VALUES (1, 'Clean Code', 1, 1)
ON DUPLICATE KEY UPDATE
    total_copies     = total_copies + 1,
    available_copies = available_copies + 1;

-- Step 2: upsert the donor (ignore if donor already exists)
INSERT INTO DONORS (name)
VALUES ('Rahul Sharma')
ON DUPLICATE KEY UPDATE donor_id = LAST_INSERT_ID(donor_id);

-- Step 3: log the donation
INSERT INTO DONATION_RECORDS (book_id, donor_id)
VALUES (
    (SELECT book_id FROM BOOKS  WHERE title = 'Clean Code'),
    (SELECT donor_id FROM DONORS WHERE name  = 'Rahul Sharma')
);


-- ============================================================
--  SECTION 6: LendBooks() — borrow a book
-- ============================================================

-- Guard 1: check whether the book exists
SELECT COUNT(*) AS book_exists
FROM BOOKS
WHERE title = 'Clean Code';

-- Guard 2: check whether copies are available
SELECT available_copies
FROM BOOKS
WHERE title = 'Clean Code';

-- Guard 3: check whether this member already has an active copy
SELECT COUNT(*) AS already_borrowed
FROM LEND_RECORDS lr
JOIN BOOKS   b ON b.book_id   = lr.book_id
JOIN MEMBERS m ON m.member_id = lr.member_id
WHERE b.title = 'Clean Code'
  AND m.name  = 'Suyash'
  AND lr.status = 'active';

-- If all guards pass: register the borrow
INSERT INTO LEND_RECORDS (book_id, member_id)
VALUES (
    (SELECT book_id   FROM BOOKS   WHERE title = 'Clean Code'),
    (SELECT member_id FROM MEMBERS WHERE name  = 'Suyash')
);

-- Decrement available count
UPDATE BOOKS
SET available_copies = available_copies - 1
WHERE title = 'Clean Code'
  AND available_copies > 0;


-- ============================================================
--  SECTION 7: ReturnBook() — return a borrowed book
-- ============================================================

-- Guard: verify this member actually borrowed the book
SELECT COUNT(*) AS valid_borrow
FROM LEND_RECORDS lr
JOIN BOOKS   b ON b.book_id   = lr.book_id
JOIN MEMBERS m ON m.member_id = lr.member_id
WHERE b.title = 'Clean Code'
  AND m.name  = 'Suyash'
  AND lr.status = 'active';

-- Mark the record as returned
UPDATE LEND_RECORDS
SET status      = 'returned',
    returned_on = CURRENT_DATE
WHERE book_id   = (SELECT book_id   FROM BOOKS   WHERE title = 'Clean Code')
  AND member_id = (SELECT member_id FROM MEMBERS WHERE name  = 'Suyash')
  AND status    = 'active';

-- Increment available count
UPDATE BOOKS
SET available_copies = available_copies + 1
WHERE title = 'Clean Code';


-- ============================================================
--  SECTION 8: BONUS QUERIES
-- ============================================================

-- 8a. List all books currently on loan (active borrows)
SELECT
    m.name        AS borrower,
    b.title       AS book,
    lr.borrowed_on
FROM LEND_RECORDS lr
JOIN MEMBERS m ON m.member_id = lr.member_id
JOIN BOOKS   b ON b.book_id   = lr.book_id
WHERE lr.status = 'active'
ORDER BY lr.borrowed_on;

-- 8b. Full borrow history for a specific member
SELECT
    b.title,
    lr.borrowed_on,
    lr.returned_on,
    lr.status
FROM LEND_RECORDS lr
JOIN BOOKS   b ON b.book_id   = lr.book_id
JOIN MEMBERS m ON m.member_id = lr.member_id
WHERE m.name = 'Suyash'
ORDER BY lr.borrowed_on DESC;

-- 8c. All donors for a specific book
SELECT
    d.name       AS donor,
    dr.donated_on
FROM DONATION_RECORDS dr
JOIN DONORS d ON d.donor_id = dr.donor_id
JOIN BOOKS  b ON b.book_id  = dr.book_id
WHERE b.title = 'Clean Code'
ORDER BY dr.donated_on;

-- 8d. Books that are fully out of stock
SELECT title, total_copies
FROM BOOKS
WHERE available_copies = 0
ORDER BY title;

-- 8e. Most borrowed books (all time)
SELECT
    b.title,
    COUNT(lr.lend_id) AS times_borrowed
FROM LEND_RECORDS lr
JOIN BOOKS b ON b.book_id = lr.book_id
GROUP BY b.book_id, b.title
ORDER BY times_borrowed DESC;

-- 8f. Total donations per donor
SELECT
    d.name            AS donor,
    COUNT(dr.donation_id) AS books_donated
FROM DONATION_RECORDS dr
JOIN DONORS d ON d.donor_id = dr.donor_id
GROUP BY d.donor_id, d.name
ORDER BY books_donated DESC;
