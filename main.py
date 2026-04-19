import asyncio
import time
import random

async def async_function(n):
    await asyncio.sleep(random.random())
    return n * n

async def main_async():
    tasks = [async_function(i) for i in range(10)]
    results = await asyncio.gather(*tasks)
    return results

def sync_function(n):
    time.sleep(random.random())
    return n * n

def main_sync():
    results = [sync_function(i) for i in range(10)]
    return results

start_time = time.time()
main_async_result = asyncio.run(main_async())
end_time = time.time()
async_time = end_time - start_time

start_time = time.time()
main_sync_result = main_sync()
end_time = time.time()
sync_time = end_time - start_time

print(f"Async result: {main_async_result}")
print(f"Sync result: {main_sync_result}")
print(f"Async time: {async_time} seconds")
print(f"Sync time: {sync_time} seconds")

if async_time < sync_time:
    print("Async is faster")
else:
    print("Sync is faster")

async def async_function2(n):
    await asyncio.sleep(random.random())
    return n * n

async def main_async2():
    tasks = [async_function2(i) for i in range(100)]
    results = await asyncio.gather(*tasks)
    return results

def sync_function2(n):
    time.sleep(random.random())
    return n * n

def main_sync2():
    results = [sync_function2(i) for i in range(100)]
    return results

start_time = time.time()
main_async_result2 = asyncio.run(main_async2())
end_time = time.time()
async_time2 = end_time - start_time

start_time = time.time()
main_sync_result2 = main_sync2()
end_time = time.time()
sync_time2 = end_time - start_time

print(f"Async result2: {main_async_result2}")
print(f"Sync result2: {main_sync_result2}")
print(f"Async time2: {async_time2} seconds")
print(f"Sync time2: {sync_time2} seconds")

if async_time2 < sync_time2:
    print("Async is faster")
else:
    print("Sync is faster")

import concurrent.futures

def sync_function3(n):
    time.sleep(random.random())
    return n * n

def main_sync3():
    with concurrent.futures.ThreadPoolExecutor() as executor:
        results = list(executor.map(sync_function3, range(100)))
    return results

start_time = time.time()
main_sync_result3 = main_sync3()
end_time = time.time()
sync_time3 = end_time - start_time

print(f"Sync result3: {main_sync_result3}")
print(f"Sync time3: {sync_time3} seconds")