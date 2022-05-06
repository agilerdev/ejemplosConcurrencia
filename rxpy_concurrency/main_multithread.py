import multiprocessing
import random
import time
from threading import current_thread
import rx
from rx.scheduler import ThreadPoolScheduler
from rx import operators as ops

numeroHilos = multiprocessing.cpu_count()
threadPoolScheduler = ThreadPoolScheduler(numeroHilos)
print("Número de hilos: {0}".format(numeroHilos))
def anadirDelay(value):
   time.sleep(random.randint(5, 20) * 0.1)
   return value

#  Tarea 1 
rx.of(1,2,3,4,5).pipe(
   ops.map(lambda a: anadirDelay(a)),
   ops.subscribe_on(threadPoolScheduler)
).subscribe(
   lambda s: print("Desde tarea 1: {0}".format(s)),
   lambda e: print(e),
   lambda: print("Tarea 1 completada")
)

# Task 2
rx.range(1, 5).pipe(
   ops.map(lambda a: anadirDelay(a)),
   ops.subscribe_on(threadPoolScheduler)
).subscribe(
   lambda s: print("Desde tarea 2: {0}".format(s)),
   lambda e: print(e),
   lambda: print("Tarea 2 completada")
)
input("Presione cualquier tecla para salir\n")