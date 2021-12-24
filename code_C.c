#include <stdio.h>

//Прототипы функции
int countZero(unsigned char n);
int exchange(int tempI, int tempJ, unsigned int n, unsigned int b, unsigned int x, unsigned int r);
void print_2(int num);


int main()
{
	unsigned int n = 8;    //Количество битов для замены
	unsigned int b = 0xDEADBEEF;    //Число
	unsigned int r = 0; //Результат замены битов
	unsigned int x = 0;
	printf("%X\n", b);
	print_2(b);

	//Пузырьковая сортировка
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 4 - i; j++) {
			unsigned int* pB = &b; //Адрес переменной
			unsigned char A = *((char*)pB + 3 - j);
			unsigned char B = *((char*)pB + 3 - j - 1);
			//printf("%X >= %X (%d >= %d)\n", A, B, countZero(A), countZero(B));
			//printf("%d\n", j * 8);
			if (countZero(A) >= countZero(B)) {

				//Позиции битов которые нужно заменить
				int tempI = (int)(24 - j * 8);
				int tempJ = (int)(24 - (j + 1) * 8);

				//Алгоритм замены
				b = exchange(tempI, tempJ, n, b, x, r);
				/*1) Побитового сдвигаем вправо так, чтобы на месте младшего бита оказались байты, которые мы хотим поменять местами
				2) XOR'им числа, сдвинутые согласно 1му пункту
				Алгоритм работает по аналогии с обычным обменом значений переменных при помощи XOR'а за исключением того, что
					мы обмениваем отдельные байты.*/

			}

		}
	}
	printf("%X\n", b);
	print_2(b);

	return 0;
}


int exchange(int tempI, int tempJ, unsigned int n, unsigned int b, unsigned int r, unsigned int x) {
	x = ((b >> tempI) ^ (b >> tempJ)) & ((1U << n) - 1);
	r = b ^ ((x << tempI) | (x << tempJ));
	b = r;
	return b;
}
//Прототип функции подсчета нулей для сравнения
int countZero(unsigned char n) {
	int counter = 0;
	for (int i = 0; i < 8; i++) {
		if (n & 1) {}
		else {
			counter++;
		}

		n >>= 1;
	}
	return counter;
}

//Функция вывода числа в двоичной системе счисления
void print_2(int num) {
	int a = 0;
	for (int c = 31; c >= 0; c--) {
		a = num >> c;
		if (a & 1)
			printf("1");
		else
			printf("0");
	}
	printf("\n");
}	