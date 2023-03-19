# ProcessMemoryInfo
A simple tool to visualize process memory usage.

## About

The memory value shown in the Windows Task Manager represents the current amount of physical memory (RAM) being used by a process. This value includes both the private working set and any shared memory that the process is using. It does not include memory that has been paged to disk (paged pool memory).

The memory value shown in the Task Manager can be useful for getting a quick estimate of the current memory usage of a process, but it may not provide a complete picture of the process's memory usage. The Task Manager does not provide detailed information about the various types of memory being used by a process or how that memory is being allocated and freed.

In contrast, the ProcessMemoryInfo view a detailed set of memory usage parameters, including the working set size, peak working set size, private usage, page file usage, paged pool usage, non-paged pool usage, and others. These parameters provide a more detailed and nuanced view of a process's memory usage than the memory value shown in the Task Manager.

Overall, the memory value shown in the Task Manager can be a useful starting point for monitoring a process's memory usage, but for more detailed analysis and optimization, it's generally better to use the more detailed memory usage parameters provided by the [GetProcessMemoryInfo] function.

## Tech

[AutoIt v3.3.14.5] - AutoIt v3 freeware BASIC-like scripting language 

## Feedback

Test and [send me] not only bugs but also wishes, best wishes;)

## License

MIT

**Free Software, Hell Yeah!**

   [GetProcessMemoryInfo]: <https://learn.microsoft.com/en-us/windows/win32/api/psapi/nf-psapi-getprocessmemoryinfo>
   [AutoIt v3.3.14.5]: <https://www.autoitscript.com>
   [send me]: <https://www.linkedin.com/in/artiomageev>
