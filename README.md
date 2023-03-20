# ProcessMemoryInfo
A simple tool to visualize process memory usage.

## About

The memory value shown in the Windows Task Manager represents the current amount of physical memory (RAM) being used by a process. This value includes both the private working set and any shared memory that the process is using. It does not include memory that has been paged to disk (paged pool memory).

The memory value shown in the Task Manager can be useful for getting a quick estimate of the current memory usage of a process, but it may not provide a complete picture of the process's memory usage. The Task Manager does not provide detailed information about the various types of memory being used by a process or how that memory is being allocated and freed.

In contrast, the ProcessMemoryInfo view a detailed set of memory usage parameters, including the working set size, peak working set size, private usage, page file usage, paged pool usage, non-paged pool usage, and others. These parameters provide a more detailed and nuanced view of a process's memory usage than the memory value shown in the Task Manager.

Overall, the memory value shown in the Task Manager can be a useful starting point for monitoring a process's memory usage, but for more detailed analysis and optimization, it's generally better to use the more detailed memory usage parameters provided by the [GetProcessMemoryInfo] function:

*1. PageFaultCount* - This value represents the number of page faults that have occurred for the process. A page fault occurs when a process tries to access a virtual memory address that is not currently in physical memory and has to be loaded from disk. Monitoring this variable can provide insights into the memory access patterns of a process and help identify potential bottlenecks or performance issues.

*2. PeakWorkingSetSize* - This value represents the maximum working set size of a process, in bytes, since it was created or since the last time the value was reset. Monitoring this variable can provide insights into the peak memory usage of a process and help identify memory-intensive operations or conditions.

*3. WorkingSetSize* - The working set of a process is the set of pages in its virtual address space that are currently resident in physical memory (RAM) and actively being used by the process. It can be useful for monitoring the memory usage of a process. 

*4.QuotaPeakPagedPoolUsage* - This value represents the maximum paged pool usage of a process, in bytes, since it was created or since the last time the value was reset. Monitoring this variable can provide insights into the peak paged pool usage of a process and help identify potential issues with kernel-mode components.

*5. QuotaPagedPoolUsage* - The paged pool is a portion of the system virtual memory that is used to store kernel-mode data that can be temporarily swapped out of physical memory and into the paging file on disk. Paged pool memory is typically used by device drivers and other kernel-mode components of an operating system, and its usage can be an important indicator of the health and stability of the system.

*6. QuotaPeakNonPagedPoolUsage* - This value represents the maximum non-paged pool usage of a process, in bytes, since it was created or since the last time the value was reset. Monitoring this variable can provide insights into the peak non-paged pool usage of a process and help identify potential issues with kernel-mode components.

*7. QuotaNonPagedPoolUsage* - This value represents the current non-paged pool usage of a process, in bytes. The non-paged pool is a portion of the system virtual memory that is used to store kernel-mode data that cannot be swapped out of physical memory. High values for this variable can indicate excessive usage of kernel-mode resources or potential memory leaks in the kernel-mode code.

*8. PagefileUsage* - This value represents the current pagefile usage of a process, in bytes. The pagefile is a reserved portion of the disk that is used to store data that cannot fit in physical memory. High values for this variable can indicate that the process is consuming a lot of virtual memory or that the system is running low on physical memory.

*9. PeakPagefileUsage* - This value represents the maximum pagefile usage of a process, in bytes, since it was created or since the last time the value was reset. Monitoring this variable can provide insights into the peak virtual memory usage of a process and help identify memory-intensive operations or conditions.

*10. PrivateUsage* - This value represents the current private usage of a process, in bytes. Private bytes are portions of the process virtual address space that are not shared with other processes or system components. Monitoring this variable can provide insights into the memory usage patterns of a process and help identify potential memory leaks or excessive memory usage.

## Installation

Windows only, but not forever!

[Portable version] - Download on your PC and extract from archive
[Package version] - Chose this one if you got faulty virus alert (It is possible to see malware caution because I haven't got valid certificate)

## Tech

[AutoIt v3.3.14.5] - AutoIt v3 freeware BASIC-like scripting language 

## Feedback

Test and [send me] not only bugs but also wishes, best wishes;)

## License

MIT

**Free Software, Hell Yeah!**

   [GetProcessMemoryInfo]: <https://learn.microsoft.com/en-us/windows/win32/api/psapi/nf-psapi-getprocessmemoryinfo>
   [Portable version]: <https://github.com/artsiomaheyeu/ProcessMemoryInfo/releases/download/v1.0/meme.exe>
   [Package version]: <https://github.com/artsiomaheyeu/ProcessMemoryInfo/releases/download/v1.0/meme.cmd>
   [AutoIt v3.3.14.5]: <https://www.autoitscript.com>
   [send me]: <https://www.linkedin.com/in/artiomageev>
