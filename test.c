int main() {
    
    int print;
    print = 99;
    
    int a;
    a = 2;
    int i;
    i = 3;
    
    if (i == a) {
        printf(print);
        i = a+4;
    }
    else if (a == 1) {
        printf(print);
        a = 2;
    }
    else {
        printf(print);
        a = 0;
    }
    printf(a);
}
