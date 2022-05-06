#include <iostream>

void function1()
{
  for (int i = 0; i < 100; i++)
  {
    std::cout << "Hello world 1" << std::endl;
  }
}
void function2()
{
  for (int i = 0; i < 100; i++)
  {
    std::cout << "Hello world 2" << std::endl;
  }
}

int main()
{
  function1();
  function2();
  return 0;
}