import datetime


def stopwatch(func):
    def inner(*args):
        start = datetime.datetime.now()
        func(*args)
        end = datetime.datetime.now()
        delta = end - start
        milliseconds = int(delta.total_seconds() * 1000)

        if milliseconds > 0:
            print(f'    Time  : {milliseconds}ms')
        else:
            microseconds = int(delta.total_seconds() * 1000000)
            print(f'    Time  : {microseconds}µs')

        print('')

    return inner
