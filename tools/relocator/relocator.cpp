//	relocator.cpp
//	compare two binary files compiled to different 
//	addresses (i.e. 0x0000 and 0x0101) and output
//	differences (i.e. relocation table).
//
//	notes:	build:	g++ -o relocator.exe relocator.cpp
//
//	tomaz stih mon oct 21 2013
#include <iostream>
#include <fstream>
#include <fstream>	// std::ifstream
#include <vector>

using namespace std;

int compare_files(const std::string &filename1, const std::string &filename2) {

	int size1, size2;
	ifstream first, second;
	first.open(filename1.c_str(), ios::in | ios::binary);
	second.open(filename2.c_str(), ios::in | ios::binary);
	vector<char> *rel_table=new vector<char>();

	// Size must be the same.
	first.seekg (0, first.end);
	size1= first.tellg();
	first.seekg (0, first.beg);

	second.seekg (0, second.end);
	size2= second.tellg();
	second.seekg (0, second.beg);

	if (size1==size2) {
		int pos=0;
		int prev=-1;
		char *b1=new char[size1];
		char *b2=new char[size2];
		first.read(b1,size1);
		second.read(b2,size2);
		while (pos<size1) {
			if (b1[pos]!=b2[pos]) {
				if (prev>0 && prev+1==pos) { // Its high byte of word
				} else {
					if (pos + 1 < size1) { // It must not be the last byte!
						// Make sure you write low byte first.
						char lo, hi;
						lo=pos&0x00FF;
						hi=(pos>>8)&0x00FF;
						rel_table->push_back(lo);
						rel_table->push_back(hi);
					}
					prev=pos;
				}
			}
			pos++;
		}
		delete[] b1;
		delete[] b2;

		int total_entries=rel_table->size() / 2;
		char lo, hi;
		lo=total_entries&0x00FF;
		hi=(total_entries>>8)&0x00FF;
		cout << lo << hi;

		for (int n=0;n<rel_table->size();n++) {
			cout << rel_table->at(n);
		}
	}  // if (size1==size2)
		else cerr << "size should be the same" << endl;

	delete rel_table;

	first.close();
	second.close();
}

int main(int argc, char *argv[])
{
	if (argc!=3) {
		cerr << "invalid command line parameter" << endl << "usage: relocator <file 0x0000> <file 0x0101>" << endl;
		return 1;
	}
	compare_files(argv[1], argv[2]);
	return 0;
}