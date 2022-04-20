int main() {
    
    int a;
    a = 1;
    int i;
    i = 3;
    
    if (i == a) {
        i = a+4;
    }
    int b;
    else if (a == 1) {
        a = 2;
        if (a == 2) {
            printf(a);
            a = 9;
        }
    }
    else {
        a = 0;
    }
    printf(a);
}
