# 📚 Library Management System — C++ Data Structures Project

A **complete Library Management System (LMS)** built in **C++** using efficient **STL data structures** such as `unordered_map`, `vector`, and `string`. This project demonstrates real-world implementation of **data structures & algorithms** for academic library operations including book management, borrowing, donations, and inventory tracking.

---

## 🚀 Project Overview

This system is a **menu-driven console application** designed to simulate the working of a real library. It allows administrators to:

- Manage book inventory  
- Track book donors  
- Issue and return books  
- Prevent duplicate borrowing  
- Display real-time stock updates  

Built with a strong focus on **time complexity, space efficiency, and STL best practices**.

---

## ✨ Key Features

✅ Add Books with Quantity Tracking  
✅ Donate Books with Donor Records  
✅ Borrow Books with Duplicate Prevention  
✅ Return Books with Validation  
✅ Display Real-Time Inventory  
✅ User-Friendly Menu Interface  

---

## 🛠 Data Structures Used

| Data Structure | Purpose | Time Complexity |
|----------------|----------|------------------|
| `unordered_map<string, int>` | Book Inventory (title → quantity) | **O(1)** |
| `unordered_map<string, vector<string>>` | Borrower Records | **O(1)** |
| `unordered_map<string, vector<string>>` | Donor Records | **O(1)** |
| `vector<string>` | Dynamic Borrower/Donor Lists | **O(1)** amortized |

---

## 🎯 Core Algorithms & Complexity

| Operation | Time Complexity |
|------------|------------------|
| Add Books | **O(m)** |
| Display All Books | **O(n)** |
| Borrow Book | **O(k)** |
| Return Book | **O(k)** |
| Process Donation | **O(m × d)** |

> Where:
- `n` = number of unique books  
- `m` = number of books inserted  
- `k` = borrowers of a specific book  
- `d` = donors per book  

---

## 🧑‍💻 How to Run the Project

### ✅ Step 1: Clone the Repository
```bash
git clone https://github.com/mishrasr8/library-management-system.git
```
### ✅ Step 2: Compile the Program
```bash
g++ -std=c++11 aat1.cpp -o library_system
```
### ✅ Step 3: Run the Program
```bash
./library_system
```
### 📱 Sample Output
```pgsql
Enter The Name Of the Library: City Central Library

1. Display Books    2. Add Books    3. Donate Books
4. Borrow Book      5. Return Book  0. Exit
Type Here: 2

Enter The No. of Books to Add: 2
Enter The Name Of the Book: The Great Gatsby
Enter The Name Of the Book: 1984
----Book Added Successfully---

------ Books in Library ------
The Great Gatsby : 1
1984 : 1
------------------------------
```
## 🎓 Academic Value

### ✅ Best For:
- Data Structures & Algorithms Course  
- C++ STL Learning  
- College Mini / Major Projects  
- GitHub Portfolio Showcase  
- Algorithm Complexity Analysis  

### ✅ Learning Outcomes:
- Hash Tables & Collision Handling  
- Dynamic Arrays using `vector`  
- Efficient Searching & Lookup  
- Time & Space Complexity Optimization  
- Menu-Driven Program Design  

---

## 📊 Performance Metrics

| Operation        | Time Complexity | Space Complexity |
|------------------|------------------|------------------|
| Book Lookup      | **O(1)**         | **O(1)**         |
| Add Book         | **O(1)**         | **O(1)**         |
| Borrow / Return  | **O(k)**         | **O(1)**         |
| Display All      | **O(n)**         | **O(1)**         |

---

## 🔮 Future Enhancements

- [ ] File Handling (Persistent Storage)  
- [ ] Database Integration (MySQL / SQLite)  
- [ ] Fine Calculation System  
- [ ] Advanced Book Search (Author/Category)  
- [ ] Multi-User Support  
- [ ] GUI Version (Qt / SFML)  

---

## 🛠 Tech Stack

```vbnet
Language: C++
Standard: C++11 / C++14 / C++17
STL: unordered_map, vector, string
Compiler: G++
IDE: VS Code / Dev-C++ / Code::Blocks
```

---

## 👨‍💻 Author

**Suyash Mishra**  
🎓 Electrical and Electronics Student  
📘 Course: Data Structures & Algorithms  
🏫 College: BMS College of Engineering  
📅 Date: December 2025  

---

⭐ **If this project helped you, don’t forget to star the repository!**  
📢 Perfect for **college submissions & GitHub portfolios**  
