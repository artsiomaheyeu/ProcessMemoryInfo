#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         Artsiom Ah(Ad)

 Script Function:
	A simple tool to visualize process memory usage: WinAPI Module

_WinAPI_GetProcessMemoryInfo() return an array that contains the following information:

[0] PageFaultCount - The number of page faults.
[1] PeakWorkingSetSize - The peak working set size, in bytes.
[2] WorkingSetSize - The current working set size, in bytes.
[3] QuotaPeakPagedPoolUsage - The peak paged pool usage, in bytes.
[4] QuotaPagedPoolUsage - The current paged pool usage, in bytes.
[5] QuotaPeakNonPagedPoolUsage - The peak nonpaged pool usage, in bytes.
[6] QuotaNonPagedPoolUsage - The current nonpaged pool usage, in bytes.
[7] PagefileUsage - The current space allocated for the pagefile, in bytes. The Commit Charge value for this process. 
					Commit Charge is the total amount of private memory that the memory manager has committed for a running process.
					(!)Windows 7 and Windows Server 2008 R2 and earlier:  PagefileUsage is always zero. Check PrivateUsage instead.
[8] PeakPagefileUsage - The peak space allocated for the pagefile, in bytes. (The peak value in bytes of the Commit Charge during the lifetime of this process.)
[9] PrivateUsage - Same as PagefileUsage. The current amount of memory that cannot be shared with other processes, in bytes. 
				   The Commit Charge value in bytes for this process. Commit Charge is the total amount of private memory that the memory manager has committed for a running process.
#ce ----------------------------------------------------------------------------

#include <WinAPIProc.au3>
#include <Array.au3>

Const $iBeapFrequency 		= 600 	; The frequency of the beep in hertz. Can be anywhere from 37 through 32,767 (0x25 through 0x7FFF). Default is 500 Hz.
Const $iDuration 			= 100	; The length of the beep in milliseconds. Default = 1000 ms.

Const $__PAGEFAULTCOUNTINFO = "In computer operating systems, a page fault occurs when a program tries to access a memory page that is currently" & _
							"not present in its allocated physical memory space. This may happen when a program accesses memory that has been" & _
							"swapped out to disk, or when the program tries to allocate more memory than is currently available in physical memory." & _
							"The number of page faults is a memory statistic that indicates how many times a process has triggered a page fault" & _
							"while running. This metric can be useful in determining how efficient a program is in managing its memory usage." & _
							"A higher number of page faults can indicate that a program is accessing a lot of memory that is not currently present" & _
							"in physical memory, which can result in slower performance due to the overhead of swapping memory in and out of disk." & @CRLF & @CRLF & _
							"Therefore, monitoring the number of page faults can help administrators and developers optimize the performance of" & _
							"their programs by identifying memory access patterns that may be causing excessive page faults and taking steps to" & _
							"reduce them, such as optimizing memory usage or increasing the amount of physical memory available to the system."

Const $__PEAKWORKINGSETSIZEINFO = "The peak working set size of a process is a memory statistic that represents the maximum amount of physical memory," & _
							"or RAM, that the process has used during its lifetime. It is the highest amount of memory that was actively used by the" & _
							"process at any point in time." & _
							"The working set of a process refers to the set of memory pages that the process is currently using or has recently used." & _
							"The peak working set size represents the maximum size of this set over the lifetime of the process." & @CRLF & @CRLF & _
							"This statistic can be useful for understanding the memory usage patterns of a process and for optimizing its performance." & _
							"By monitoring the peak working set size, you can identify memory-intensive parts of the code and try to optimize them." & _
							"Additionally, if the peak working set size exceeds the available memory on the system, it can lead to performance issues" & _
							"such as paging, thrashing, and swapping."

Const $__WORKINGSETSIZEINFO = "The current working set size refers to the amount of memory that a process is currently using and has in physical" & _
							"RAM (Random Access Memory). It includes all the memory pages that the process is actively using or has used recently." & _
							"In simpler terms, the current working set size is the portion of a process's memory that is actively being used at any" & _
							"given time. This information is useful for monitoring and managing the memory usage of a process and can help identify" & _
							"potential performance issues." & _
							"The working set size can change over time as a process allocates and deallocates memory, and the operating system manages" & _
							"the process's memory pages in physical memory and in virtual memory."

Const $__QUOTAPEAKPAGEDPOOLUSAGEINFO = "The peak paged pool usage is a memory statistic that refers to the maximum amount of paged pool memory that a process" & _
							"has used during its lifetime. Paged pool memory is a portion of system memory that is used by the operating system to" & _
							"store data that can be swapped to disk when not in use, freeing up space for other applications." & _
							"The paged pool is used for objects that can be written to disk and reloaded, such as file system metadata and driver code." & _
							"When a process needs to allocate memory from the paged pool, it requests the memory from the operating system's memory" & _
							"manager, which allocates a block of memory from the paged pool." & @CRLF & @CRLF & _
							"The peak paged pool usage for a process indicates the maximum amount of memory that the process has allocated from the" & _
							"paged pool. This can be useful for diagnosing performance issues or memory leaks in a process, as it indicates the highest" & _
							"amount of paged pool memory that the process has used over its lifetime."

Const $__QUOTAPAGEDPOOLUSAGEINFO = "The paged pool is a portion of the system virtual memory that is used to store kernel-mode data that can be temporarily swapped out" & _ 
							"of physical memory and into the paging file on disk." & _
							"Paged pool memory is typically used by device drivers and other kernel-mode components of an operating system, and its usage can be" & _  
							"an important indicator of the health and stability of the system. A high value for the Quota Paged Pool Usage may indicate that a process" & _  
							"is using a lot of kernel-mode resources, such as device drivers or system services, or that there may be memory leaks or other issues" & _  
							"in the kernel-mode code." & @CRLF & @CRLF & _
							"Monitoring this value of a process can be useful in identifying processes or components that are consuming excessive" & _  
							"amounts of paged pool memory, which can cause performance issues or system instability. In addition, comparing this value across" & _  
							"multiple processes can help identify which processes are using the most paged pool memory and potentially competing for" & _  
							"limited system resources."

Const $__QUOTAPEAKNONPAGEDPOOLUSAGEINFO = "In computing, the nonpaged pool is a portion of memory used by the Windows operating system to store data that cannot" & _
							"be paged out to the disk. It is a type of system memory that is allocated to kernel-mode drivers and other system components." & _
							"Nonpaged pool memory is essential for the proper functioning of the operating system and its drivers." & _
							"The peak nonpaged pool usage is a measure of the highest amount of nonpaged pool memory that was used by a process during" & _
							"its execution. This statistic is useful for identifying memory leaks or other memory-related issues that may be affecting" & _
							"the performance of a system. If a process is using an excessive amount of nonpaged pool memory, it can cause system" & _
							"instability, crashes, or other problems." & @CRLF & @CRLF & _
							"To monitor the nonpaged pool usage of a process, you can use the Windows Performance Monitor tool, which provides real-time" & _
							"statistics on system performance, including memory usage. By monitoring the peak nonpaged pool usage of a process, you can" & _
							"identify any issues with memory usage and take steps to optimize the system for better performance."

Const $__QUOTANONPAGEDPOOLUSAGEINFO = "The nonpaged pool is a region of memory in the Windows operating system that is reserved for kernel-mode components" & _
							"and drivers. This pool of memory is used for storing data that cannot be written to disk, such as memory used by device" & _
							"drivers, network protocols, and other system components." & _
							"The current nonpaged pool usage refers to the amount of memory in the nonpaged pool that is currently being used by" & _
							"a specific process. This information can be viewed using tools like the Windows Task Manager or Resource Monitor." & @CRLF & @CRLF & _
							"When a process uses memory that is allocated from the nonpaged pool, it can cause the nonpaged pool to become exhausted," & _
							"which can result in system instability and crashes. Therefore, monitoring the nonpaged pool usage of individual processes" & _
							"can help identify memory leaks and other issues that may be causing system performance problems."

Const $__PAGEFILEUSAGEINFO  = "The Commit Charge value refers to the amount of virtual memory that a process has reserved for its use on the system." & _
							"Virtual memory is a technique used by operating systems to provide a larger address space to programs than the amount of" & _
							"physical memory that is actually available in the system." & _
							"The Commit Charge value includes both the amount of physical memory that the process is using (known as 'Working Set') and" & _
							"the amount of virtual memory that the process has reserved but has not yet used. This reserved virtual memory is referred" & _
							"to as Commit Size." & _
							"In other words, the Commit Charge value represents the maximum amount of memory that a process could potentially use," & _
							"including both physical and virtual memory. If the system runs out of physical memory, it will start to use the reserved" & _
							"virtual memory to store data, which can cause performance issues due to the slower access times of virtual memory compared" & _
							"to physical memory."

Const $__PEAKPAGEFILEUSAGEINFO = "The Commit Charge is the amount of virtual memory that has been reserved by a process in the system's paging file," & _
							"which is used as a backup when the physical memory (RAM) is full. The peak value of the Commit Charge for a process" & _
							"refers to the highest amount of virtual memory that the process has reserved in the paging file during its lifetime." & @CRLF & @CRLF & _
							"In other words, this statistic represents the maximum amount of memory the process has requested from the operating system," & _
							"including both the physical RAM and the backup paging file. This value can be useful in understanding the memory usage" & _
							"patterns of a particular process and can help in identifying potential memory leaks or performance issues."

Const $__PRIVATEUSAGEINFO   = "The Commit Charge value in bytes for this process. Commit Charge is the total amount of private memory that the memory" & _
							"manager has committed for a running process."

Const $INFOHEADER[10][3]    = [["PageFaultCount", "The number of page faults.", $__PAGEFAULTCOUNTINFO], _	
                            ["PeakWorkingSetSize", "The peak working set size, in bytes.", $__PEAKWORKINGSETSIZEINFO], _
                            ["WorkingSetSize", "The current working set size, in bytes.", $__WORKINGSETSIZEINFO], _
                            ["QuotaPeakPagedPoolUsage", "The peak paged pool usage, in bytes.", $__QUOTAPEAKPAGEDPOOLUSAGEINFO], _
                            ["QuotaPagedPoolUsage", "The current paged pool usage, in bytes.", $__QUOTAPAGEDPOOLUSAGEINFO], _
                            ["QuotaPeakNonPagedPoolUsage", "The peak nonpaged pool usage, in bytes.", $__QUOTAPEAKNONPAGEDPOOLUSAGEINFO], _
                            ["QuotaNonPagedPoolUsage", "The current nonpaged pool usage, in bytes.", $__QUOTANONPAGEDPOOLUSAGEINFO], _
                            ["PageFileUsage", "The Commit Charge value in bytes for this process.", $__PAGEFILEUSAGEINFO], _
                            ["PeakPageFileUsage", "The peak value in bytes of the Commit Charge during the lifetime of this process.", $__PEAKPAGEFILEUSAGEINFO], _
                            ["PrivateUsage", "The Commit Charge value in bytes for this process.", $__PRIVATEUSAGEINFO]]

Func MEMSTAT($iPID, $bBeapFlag = False)
	If $bBeapFlag Then Beep($iBeapFrequency, $iDuration)
	Local $aMemStats[10]
	If Not ProcessExists($iPID) Then Return Null
	$aMemStats = _WinAPI_GetProcessMemoryInfo($iPID)
	Return $aMemStats
EndFunc

Func _Extract($sKey, $sValue, $aArray=$INFOHEADER)
	Switch $sValue
		Case "Key"
			Return _ArraySearch($aArray, $sKey)
		Case "Title"
			Return $aArray[_ArraySearch($aArray, $sKey)][1]
		Case "Description"
			Return $aArray[_ArraySearch($aArray, $sKey)][2]
		Case Else
			Return Null
	EndSwitch
	If @error Then Return Null
EndFunc
