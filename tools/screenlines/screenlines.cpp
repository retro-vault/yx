#include <iostream>

using namespace std;

int main() {
	int vmem=16384;
	int line=0;
	int addr=vmem;
	int offset=0;
	while (line < 192) {
		cout << "\t\t.word " << addr + offset << "\t\t\t; screen line "<<line<<"\n";
		line++;
		offset=(line % 8)*256 + ( (line & 0x38) << 2 ) + ( ( line & 0xc0 ) << 5 );
	}
	return 0;
}
