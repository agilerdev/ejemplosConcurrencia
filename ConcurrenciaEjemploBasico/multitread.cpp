#include <iostream>
#include <thread>

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
  std::thread t1(function1);
  std::thread t2(function2);

  t1.join();
  t2.join();

  return 0;
}