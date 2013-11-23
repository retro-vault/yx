#include <iostream>
#include <fstream>
#include <cstdlib>
#include <bitset>
#include <limits>
#include <sstream>
#include <string>
#include <iomanip>

using namespace std;

template<typename T> string xxx_to_bin(const T& value)
{
	const bitset<numeric_limits<T>::digits + 1> bs(value);
	const string s(bs.to_string());
	const string::size_type pos(s.find_first_not_of('0'));
	return pos == string::npos ? "0" : s.substr(pos);
}

int main(int argc, char *argv[]) {

	// First argument is filename.	
	ifstream infile(argv[1],ios::in|ios::binary);
	char b;
        while (!infile.eof()) {
		infile.read(&b,1);
		cout << setw(8) << setfill('0') << xxx_to_bin(b) << endl;
	}

	infile.close();

	return 0;
}
