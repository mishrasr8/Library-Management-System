# Library Management System --- C++ & SQL

A Library Management System implemented as **two separate versions of
the same library-management concept**:

1.  **C++ implementation** --- a console application focused on OOP, STL
    containers, inventory tracking, borrowing/returning, and donations.
2.  **SQL implementation** --- a relational database design and query
    set that models the same domain using tables, keys, relationships,
    constraints, sample data, operational queries, and reporting
    queries.

> **Important:** The C++ program and the SQL script are currently
> **separate implementations**. The C++ application does **not** connect
> to or read/write the SQL database.

Repository: https://github.com/mishrasr8/Library-Management-System

------------------------------------------------------------------------

## 📌 Project Overview

The project models common library operations:

-   Library/book inventory management
-   Adding books
-   Recording donated books and donors
-   Borrowing books
-   Returning books
-   Tracking available copies
-   Preventing a member from borrowing another active copy of the same
    book
-   Maintaining borrowing and donation history
-   Querying library activity through SQL

The repository contains:

``` text
Library-Management-System/
├── Library_Management_System.cpp
├── library_management.sql
└── README.md
```

The repository currently has a small, focused structure with the C++ and
SQL versions intentionally kept as separate artifacts.

------------------------------------------------------------------------

# 1. C++ Implementation

## 🧩 Technology Stack

-   **Language:** C++
-   **Standard:** C++11-compatible code
-   **STL:** `unordered_map`, `vector`, `string`, `<algorithm>`
-   **Interface:** Console / menu driven
-   **Persistence:** None --- data exists only while the program is
    running

The C++ implementation is contained in:

``` text
Library_Management_System.cpp
```

------------------------------------------------------------------------

## ✨ C++ Features

### 1. Library Initialization

The program asks for a library name and initializes a `Library` object.

``` text
Enter The Name Of the Library:
```

### 2. Display Books

Displays the current inventory and the number of available copies.

### 3. Add Books

Allows the user to add one or more copies of books.

If the title already exists, its quantity is incremented.

### 4. Donate Books

A donation:

-   Adds a copy to the inventory
-   Records the donor against the book
-   Avoids adding the same donor twice for the same title

### 5. Borrow Books

The program validates:

-   Whether the book exists
-   Whether a copy is available
-   Whether the same borrower already has an active copy of that title

On successful borrowing, available inventory is decremented.

### 6. Return Books

The program verifies that the borrower is associated with an active
borrowing record.

On successful return:

-   The borrower is removed from the active borrower list
-   Available inventory is incremented

------------------------------------------------------------------------

# 2. C++ Data Structures

The core class uses three `unordered_map` structures:

  -----------------------------------------------------------------------------
  Structure                                 Purpose
  ----------------------------------------- -----------------------------------
  `unordered_map<string, int>`              Book title → available quantity

  `unordered_map<string, vector<string>>`   Book title → active borrowers

  `unordered_map<string, vector<string>>`   Book title → donors
  -----------------------------------------------------------------------------

The main class is:

``` cpp
class Library
```

The primary operations are:

``` text
AddBooks()
AddDonatedBook()
DisplayBooks()
LendBooks()
ReturnBook()
```

------------------------------------------------------------------------

# 3. C++ Design Analysis

## 👍 Strengths

### Efficient average-case lookup

`unordered_map` provides average **O(1)** lookup/insertion for inventory
operations.

### Simple domain model

The `Library` class encapsulates the main state and operations instead
of keeping all data in global variables.

### STL usage

The project demonstrates practical use of:

-   Hash maps
-   Dynamic arrays
-   Iterators
-   `find`
-   `push_back`
-   `erase`

### Duplicate borrowing validation

The implementation checks the active borrower list before allowing the
same person to borrow another copy of the same title.

------------------------------------------------------------------------

## ⚠️ C++ Audit Findings

The implementation is appropriate as an academic data-structures
project, but it has several limitations that should be understood before
treating it as production software.

### 1. No persistent storage

All data is stored in memory.

When the application exits:

``` text
books
borrowers
donors
```

are lost.

The SQL implementation does not solve this automatically because the C++
program is not connected to the SQL database.

**Recommendation:** Add a database layer or file persistence.

------------------------------------------------------------------------

### 2. Book title is used as the primary identifier

Books are identified by their title:

``` cpp
unordered_map<string, int> dictofBooks;
```

This creates problems when:

-   Two editions have the same title
-   Two books have similar titles
-   Titles differ only by capitalization
-   Author information is required

**Recommendation:** Introduce a `Book` entity with a unique book
ID/ISBN.

------------------------------------------------------------------------

### 3. Borrower identity is only a string

Borrowers are stored by name.

For example:

``` text
Rahul
```

is not guaranteed to uniquely identify one person.

**Recommendation:** Use a member ID and store member details separately.

------------------------------------------------------------------------

### 4. "One book at a time" is not globally enforced

The message says:

``` text
You can only Take One Book at a time
```

but the actual validation only prevents the same borrower from borrowing
another active copy of the **same title**.

A borrower could still potentially borrow multiple different titles.

**Recommendation:** Either:

-   enforce a true one-book-per-member rule, or
-   change the message to accurately describe the implemented rule.

------------------------------------------------------------------------

### 5. Borrowing records are not historical

The C++ program removes the borrower from the active vector during
return.

Therefore, it does not preserve:

-   borrow date
-   return date
-   previous borrower history
-   overdue information

**Recommendation:** Model borrowing as a transaction/record rather than
only an active list.

------------------------------------------------------------------------

### 6. Input validation is limited

The program assumes valid numeric input for menu choices and quantities.

Invalid input such as:

``` text
abc
```

where an integer is expected can put `cin` into a failed state.

**Recommendation:** Add input validation and recovery logic.

------------------------------------------------------------------------

### 7. Ordering is not deterministic

Because `unordered_map` is used, books are not displayed in alphabetical
insertion order.

If predictable output is desired, use:

``` cpp
map<string, int>
```

or copy keys into a vector and sort them before display.

------------------------------------------------------------------------

### 8. OOP can be further improved

Although the project uses a `Library` class, most domain concepts are
still represented as primitive strings and containers.

A more scalable design could introduce:

``` text
Book
Member
Donor
Loan
Donation
Library
```

This would improve separation of concerns and extensibility.

------------------------------------------------------------------------

# 4. SQL Implementation

The SQL implementation is contained in:

``` text
library_management.sql
```

It models the same library domain using a relational database.

The script contains:

-   Table creation
-   Primary keys
-   Foreign keys
-   Sample data
-   Inventory queries
-   Book insertion/upsert logic
-   Donation records
-   Borrowing operations
-   Return operations
-   Reporting queries

------------------------------------------------------------------------

# 5. SQL Database Schema

The SQL version contains the following main tables:

``` text
LIBRARY
BOOKS
MEMBERS
DONORS
LEND_RECORDS
DONATION_RECORDS
```

## Relationship Overview

``` text
LIBRARY
   │
   └── BOOKS
          │
          ├── LEND_RECORDS ── MEMBERS
          │
          └── DONATION_RECORDS ── DONORS
```

### LIBRARY

Stores library information.

Important columns:

``` text
library_id
name
```

### BOOKS

Stores inventory.

Important columns:

``` text
book_id
library_id
title
total_copies
available_copies
```

### MEMBERS

Stores borrowers.

``` text
member_id
name
```

### DONORS

Stores donors.

``` text
donor_id
name
```

### LEND_RECORDS

Stores borrowing history.

``` text
lend_id
book_id
member_id
borrowed_on
returned_on
status
```

### DONATION_RECORDS

Stores book donation history.

``` text
donation_id
book_id
donor_id
donated_on
```

------------------------------------------------------------------------

# 6. SQL Features

## Inventory Management

The database tracks both:

``` text
total_copies
available_copies
```

This is better than the C++ model because the database can distinguish
total inventory from currently available inventory.

------------------------------------------------------------------------

## Donation Management

The SQL version records donations through a dedicated relationship
table:

``` text
DONATION_RECORDS
```

This preserves donation history instead of storing only a list of donor
names.

------------------------------------------------------------------------

## Borrowing Management

The SQL implementation checks:

1.  Book existence
2.  Available copies
3.  Whether the member already has an active copy

It then creates a row in `LEND_RECORDS` and decrements availability.

------------------------------------------------------------------------

## Return Management

On return:

``` text
status → returned
returned_on → current date
available_copies → available_copies + 1
```

This preserves the historical loan record.

------------------------------------------------------------------------

# 7. SQL Queries Included

The script includes examples for:

### Inventory

-   Display all books
-   Add/increment a book

### Donations

-   Add a donated copy
-   Create/find donor
-   Record donation

### Borrowing

-   Check book existence
-   Check availability
-   Check duplicate active borrowing
-   Create a lending record
-   Decrease available copies

### Returning

-   Validate active borrowing
-   Mark a loan as returned
-   Increase available copies

### Reports

-   Currently borrowed books
-   Member borrowing history
-   Donors for a book
-   Out-of-stock books
-   Most borrowed books
-   Total donations by donor

------------------------------------------------------------------------

# 8. SQL Audit Findings

## 👍 Strengths

### Proper relational modeling

The SQL version is significantly more structured than the in-memory C++
representation.

It uses:

-   Primary keys
-   Foreign keys
-   Separate entity tables
-   Transaction/history tables

### Historical records

Unlike the C++ implementation, the SQL design preserves borrowing and
donation history.

### Referential integrity

Foreign keys connect:

``` text
BOOKS → LIBRARY
LEND_RECORDS → BOOKS
LEND_RECORDS → MEMBERS
DONATION_RECORDS → BOOKS
DONATION_RECORDS → DONORS
```

This is a strong improvement over storing relationships as strings.

------------------------------------------------------------------------

## ⚠️ SQL Audit Findings

### 1. The SQL file is MySQL-oriented

The schema uses features such as:

``` sql
AUTO_INCREMENT
ENUM
ON DUPLICATE KEY UPDATE
LAST_INSERT_ID()
```

Therefore, it should be treated as a **MySQL/MariaDB-oriented script**,
not generic SQL.

------------------------------------------------------------------------

### 2. C++ and SQL are not integrated

This is the most important architectural observation.

The repository currently contains:

``` text
C++ application
        +
SQL database script
```

but not:

``` text
C++ application
        ↓
Database connector
        ↓
MySQL
```

So changes made in the C++ program do not appear in the SQL database,
and SQL changes do not appear in the C++ application.

------------------------------------------------------------------------

### 3. Borrow operation should be transactional

The SQL borrowing workflow performs an `INSERT` and an `UPDATE` as
separate statements.

If one operation succeeds and the other fails, inventory and lending
records could become inconsistent.

**Recommendation:** Use a transaction:

``` sql
START TRANSACTION;

-- validate
-- insert loan
-- update inventory

COMMIT;
```

and use:

``` sql
ROLLBACK;
```

on failure.

------------------------------------------------------------------------

### 4. Duplicate active borrowing should be database-enforced

The current script checks for an existing active loan using a query.

That is useful, but application-level checks alone can suffer from race
conditions in multi-user environments.

**Recommendation:** Add an appropriate database constraint/index
strategy or perform the operation inside a transaction with suitable
locking.

------------------------------------------------------------------------

### 5. Inventory consistency should be constrained

The database should prevent values such as:

``` text
available_copies < 0
available_copies > total_copies
total_copies < 0
```

**Recommendation:** Add `CHECK` constraints where supported and enforce
inventory updates atomically.

------------------------------------------------------------------------

### 6. Member names are not unique

The SQL table has:

``` sql
member_id
name
```

but `name` is not unique.

This is correct if multiple people can share a name, but operational
queries should then always use `member_id` rather than member name.

------------------------------------------------------------------------

### 7. Book title is globally unique

The schema defines:

``` sql
title VARCHAR(200) NOT NULL UNIQUE
```

This prevents two records with the same title even if they are different
editions or libraries.

A production library database would normally model:

``` text
Book
Author
Publisher
Edition
ISBN
Library
BookCopy
```

rather than treating title as the identity of a physical book.

------------------------------------------------------------------------

# 9. C++ vs SQL Implementation

  Capability              C++ Version                  SQL Version
  ----------------------- ---------------------------- -------------------------------
  Inventory               `unordered_map`              `BOOKS` table
  Members                 Strings in loan records      `MEMBERS` table
  Donors                  `unordered_map` + `vector`   `DONORS` + `DONATION_RECORDS`
  Borrowing               In-memory vector             `LEND_RECORDS`
  Return                  Removes active borrower      Updates historical loan
  Persistence             ❌ No                        ✅ Database
  Relationships           Implicit                     Foreign keys
  History                 ❌ Limited                   ✅ Yes
  Query/reporting         Limited                      ✅ Strong
  Multi-user support      ❌                           Potentially yes
  Transactions            ❌                           Can be added
  GUI/API                 ❌                           ❌
  C++ ↔ SQL integration   ❌                           ❌

------------------------------------------------------------------------

# 10. Recommended Architecture

If the objective is to turn this into a complete software project, the
next version should combine the two implementations.

A suitable architecture would be:

``` text
                ┌─────────────────────┐
                │   Console / GUI     │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │   Library Service   │
                │   / Business Logic  │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │   C++ DB Layer      │
                │ MySQL Connector/C++ │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │       MySQL         │
                │  Library Database   │
                └─────────────────────┘
```

The C++ application should then become the application/service layer
while SQL becomes the persistent data layer.

------------------------------------------------------------------------

# 11. Recommended Future Improvements

## High Priority

-   [ ] Connect C++ to MySQL
-   [ ] Use database transactions for borrow/return operations
-   [ ] Replace title-based identity with `book_id` / ISBN
-   [ ] Introduce `member_id`
-   [ ] Preserve complete loan history in C++
-   [ ] Add robust input validation
-   [ ] Add automated tests
-   [ ] Add a proper build system such as CMake

## Medium Priority

-   [ ] Add author and category support
-   [ ] Add due dates
-   [ ] Add overdue detection
-   [ ] Add fine calculation
-   [ ] Add search by title, author, ISBN, and category
-   [ ] Add librarian/admin roles
-   [ ] Add inventory consistency constraints
-   [ ] Add indexes for common SQL queries

## Advanced

-   [ ] REST API
-   [ ] GUI using Qt
-   [ ] Authentication and authorization
-   [ ] Audit logs
-   [ ] Reservation/waitlist functionality
-   [ ] Multiple library branches
-   [ ] Book-copy level tracking
-   [ ] Automated database migrations
-   [ ] CI/CD and static analysis

------------------------------------------------------------------------

# 12. Suggested Production-Level Data Model

A more complete schema could be:

``` text
LIBRARIES
    │
    ├── BOOKS
    │     │
    │     ├── AUTHORS
    │     ├── CATEGORIES
    │     └── BOOK_COPIES
    │
    ├── MEMBERS
    │
    ├── LOANS
    │
    ├── DONORS
    │
    └── DONATIONS
```

This separates a **book title/work** from an individual physical **book
copy**, which is important for real library inventory.

For example:

``` text
Book:
    Clean Code

Copies:
    CC-001
    CC-002
    CC-003
```

Each copy can then have its own status:

``` text
AVAILABLE
BORROWED
LOST
DAMAGED
MAINTENANCE
```

------------------------------------------------------------------------

# 13. How to Run the C++ Version

Clone the repository:

``` bash
git clone https://github.com/mishrasr8/Library-Management-System.git
cd Library-Management-System
```

Compile the actual C++ source file:

``` bash
g++ -std=c++11 Library_Management_System.cpp -o library_system
```

Run:

### Linux / macOS

``` bash
./library_system
```

### Windows

``` bash
library_system.exe
```

> **Note:** The repository README currently shows a compile command
> using `aat1.cpp`, but the actual repository file is
> `Library_Management_System.cpp`. The command above matches the current
> filename.

------------------------------------------------------------------------

# 14. How to Use the SQL Version

The SQL script is designed for a MySQL-compatible environment.

Typical workflow:

``` text
1. Install MySQL / MariaDB
2. Open MySQL Workbench or the MySQL CLI
3. Create/select a database
4. Execute library_management.sql
5. Run the included queries
```

Example:

``` sql
CREATE DATABASE library_management;
USE library_management;
```

Then execute:

``` text
library_management.sql
```

> Because the script uses MySQL-specific syntax, do not assume that it
> will execute unchanged on PostgreSQL or SQLite.

------------------------------------------------------------------------

# 15. Project Learning Outcomes

This project demonstrates two different approaches to the same problem.

### C++ / Data Structures

The C++ version demonstrates:

-   OOP basics
-   STL containers
-   Hash-based lookup
-   Dynamic arrays
-   Searching
-   In-memory state management
-   Menu-driven application design
-   Time-complexity reasoning

### SQL / Database Systems

The SQL version demonstrates:

-   Relational modeling
-   Primary keys
-   Foreign keys
-   Normalized entity separation
-   CRUD-style operations
-   Joins
-   Aggregation
-   Historical records
-   Inventory queries
-   Database-oriented reporting

Together, the two versions make a useful comparison between **in-memory
data structures** and **persistent relational data modeling**.

------------------------------------------------------------------------

# 16. Overall Audit Assessment

  Area                    Assessment
  ----------------------- -----------------------------------------
  Concept                 ✅ Good academic project
  C++ implementation      ✅ Functional and easy to understand
  STL usage               ✅ Good
  OOP                     🟡 Basic
  Input validation        🟠 Needs improvement
  Persistence             ❌ Not present in C++
  SQL schema              ✅ Reasonable academic relational model
  Referential integrity   ✅ Good foundation
  Transaction safety      🟠 Needs improvement
  C++/SQL integration     ❌ Not implemented
  Production readiness    🟠 Not production-ready
  Academic value          ⭐ Strong
  Extensibility           🟡 Moderate

### Overall conclusion

This repository is best understood as an **academic Library Management
System demonstrating the same domain through two independent
implementations**.

The **C++ program** focuses on data structures, STL, OOP, and in-memory
operations, while the **SQL script** focuses on relational modeling,
persistence, relationships, transaction records, and analytical queries.

The strongest next step would be to integrate the C++ application with
the SQL database and redesign the domain around stable IDs (`book_id`,
`member_id`, etc.) rather than names/titles as identifiers.

------------------------------------------------------------------------

## 📚 Repository

urlGitHub Repository ---
mishrasr8/Library-Management-Systemhttps://github.com/mishrasr8/Library-Management-System

### Main files

-   `Library_Management_System.cpp` --- C++ implementation
-   `library_management.sql` --- SQL implementation
-   `README.md` --- project documentation

------------------------------------------------------------------------

## 👨‍💻 Author

**Suyash Mishra**

Academic project focused on C++, Data Structures & Algorithms, OOP, STL,
and SQL/database concepts.
