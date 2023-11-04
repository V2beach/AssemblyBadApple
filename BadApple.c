#pragma warning(disable: 4996)
#include <stdio.h>
#include <windows.h>

void main() {//从文件读数据
	char file_name[100];
	char c[500];
	system("pause");
	for (int i = 1; i < 7777; i = i + 3) {//7777
		sprintf(file_name, "D:/ffmpeg/videoOFasm/TXT/%d.txt", i);
		FILE *fp = fopen(file_name, "r");

		while (!feof(fp)) {
			fgets(c, 500, fp);//将fp所指向的文件一行内容读到缓冲区
			//puts(c);//换行
			printf("%s", c);
		}

		//Sleep(1);
		system("cls");
		fclose(fp);
	}
	system("pause");
}