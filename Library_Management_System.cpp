#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>
#include <algorithm>
using namespace std;

class Library {

private:
    string LibraryName;
    unordered_map<string, int> dictofBooks;
    unordered_map<string, vector<string>> LendRecord;
    unordered_map<string, vector<string>> DonorRecord;

    void _Donor(const string &Book, const string &Donor) {
        if (DonorRecord.find(Book) != DonorRecord.end()) {
            auto &donors = DonorRecord[Book];
            if (find(donors.begin(), donors.end(), Donor) == donors.end()) {
                donors.push_back(Donor);
            }
        } else {
            DonorRecord[Book] = { Donor };
            for (auto &p : DonorRecord[Book]) {
                cout << "Donor record added: " << Book << " -> " << p << endl;
            }
        }
    }

public:
    Library(string name, unordered_map<string, int> books)
        : LibraryName(name), dictofBooks(books) {}

    void AddDonatedBook() {
        int NoOfBooks;
        cout << "Enter The No. of Books You want to Donate: ";
        cin >> NoOfBooks;
        cin.ignore();

        for (int i = 0; i < NoOfBooks; i++) {
            string BookName, Donor;
            cout << "Enter The Book Name: ";
            getline(cin, BookName);
            cout << "Enter The Donor Name: ";
            getline(cin, Donor);

            dictofBooks[BookName]++;  
            _Donor(BookName, Donor);
        }

        cout << "----❤️ THANK YOU for Donating ❤️----\n";
    }

    void AddBooks() {
        int NoOfBooks;
        cout << "Enter The No. of Books to Add: ";
        cin >> NoOfBooks;
        cin.ignore();

        for (int i = 0; i < NoOfBooks; i++) {
            string BookName;
            cout << "Enter The Name Of the Book: ";
            getline(cin, BookName);
            dictofBooks[BookName]++;
        }
        cout << "----Book Added Successfully---\n";
    }

    void DisplayBooks() {
        cout << "\n------ Books in Library ------\n";
        for (auto &p : dictofBooks) {
            cout << p.first << " : " << p.second << endl;
        }
        cout << "------------------------------\n";
    }

    void LendBooks() {
        cout << "----- You can only Take One Book at a time -----\n";

        string borrower, book;
        cout << "Enter The Name Of Borrower: ";
        cin.ignore();
        getline(cin, borrower);

        cout << "Enter the Book Name: ";
        getline(cin, book);

        if (dictofBooks.find(book) == dictofBooks.end()) {
            cout << "----😔 " << book << " is not present in the Library 😔----\n";
            return;
        }

        if (dictofBooks[book] <= 0) {
            cout << "----- Sorry, We are Out of Stock for " << book << " -----\n";
            return;
        }

        if (LendRecord[book].size() > 0) {
            if (find(LendRecord[book].begin(), LendRecord[book].end(), borrower) != LendRecord[book].end()) {
                cout << "--Sorry. You cannot borrow another copy of " << book << " --\n";
                return;
            }
        }

        LendRecord[book].push_back(borrower);
        dictofBooks[book]--;
    }

    void ReturnBook() {
        string book, returner;

        cin.ignore();
        cout << "Enter the name of the Book to be Returned: ";
        getline(cin, book);
        cout << "Enter the name of the Returner: ";
        getline(cin, returner);

        if (LendRecord.find(book) == LendRecord.end()) {
            cout << "----" << book << " was never borrowed----\n";
            return;
        }

        auto &borrowers = LendRecord[book];
        auto it = find(borrowers.begin(), borrowers.end(), returner);

        if (it != borrowers.end()) {
            dictofBooks[book]++;
            borrowers.erase(it);
            cout << "<< Book Returned Successfully >>\n";
        } else {
            cout << "----" << returner << " is not in the list of borrowers. Please Check Again----\n";
        }
    }
};

int main() {
    string LibraryName;
    cout << "Enter The Name Of the Library: ";
    getline(cin, LibraryName);

    unordered_map<string, int> BookDict;

    Library Lib(LibraryName, BookDict);

    while (true) {
        int userInput;
        cout << "\n1. Display Books\n2. Add Books\n3. Donate Books\n4. Borrow Book\n5. Return Book\n0. Exit\nType Here: ";

        cin >> userInput;

        switch (userInput) {
        case 1:
            Lib.DisplayBooks();
            break;
        case 2:
            Lib.AddBooks();
            break;
        case 3:
            Lib.AddDonatedBook();
            break;
        case 4:
            Lib.LendBooks();
            break;
        case 5:
            Lib.ReturnBook();
            break;
        case 0:
            cout<<"=====>Code Execution Completed<====="<<endl;;
            return 0;
        default:
            cout << "Invalid Option. Try Again.\n";
        }
    }

    return 0;
}


