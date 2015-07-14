<# Windows process monitor extension
   by Aaron Jacobs 5/27/15 #>

$i=0
	
<# takes process names as input; change path to your text file #>
$ProcPaths=@(get-content c:\ma5\MachineAgent\monitors\ProcessMonitor\proclist.txt)
	
<# get length of procList (file with list of processes to monitor) #>
$len=$procPaths | measure
$len=$len.count-1
	
<# gives total number of processes running on the machine #>
$procCount=get-process
$procCount=$procCount.length
Write-Output "name=Custom Metrics | Process Monitor | Number of Processes,value=$procCount"
$procCountHolder=$procCount-1
	
<# gives total number of services running on the machine #>
$serviceCount=get-service
$serviceCount=$serviceCount.length
Write-Output "name=Custom Metrics | Process Monitor | Number of Services,value=$serviceCount"
	
<# cycle through each process in the list #>
do
{
	$procs = get-process $ProcPaths[$i]
	
	$lenPerProc = $procs | measure
	$lenPerProc = $procs.count-1
		
	<# cycle through each instance of the process in the list #>
	$z=0
	do
	{
		$procInstance = $procs[$z].name
		
		<# $procVarName = $procs[$z].name + $z #>
		
		$identifier = $procs[$z].id
		$procVarName = $identifier
		
		$procVarCPU = $procs[$z].CPU * 1000    <# gives CPU time spent in sec.  Convert to milliseconds. #>
		$procVarCPU = [int]$procVarCPU
		Write-Output "name=Custom Metrics | Process Monitor | $procInstance | $procVarName | CPU time spent(ms),value=$procVarCPU"
		
		$procVarHandleCount = $procs[$z].Handles
		Write-Output "name=Custom Metrics | Process Monitor | $procInstance | $procVarName | Handles,value=$procVarHandleCount"
		
		$NPM = $procs[$z].NPM
		Write-Output "name=Custom Metrics | Process Monitor | $procInstance | $procVarName | Non-paged System Memory Size (bytes),value=$NPM"
		
		$PM = $procs[$z].PM
		Write-Output "name=Custom Metrics | Process Monitor | $procInstance | $procVarName | Paged Memory Size (bytes),value=$PM"
		
		$VM = $procs[$z].VM
		Write-Output "name=Custom Metrics | Process Monitor | $procInstance | $procVarName | Virtual Memory Size (bytes),value=$VM"
		
		$procThreads = $procs[$z].threads
		$procThreadsLen = $procThreads | measure
		$procThreadsLen = $procThreadsLen.count
		$procThreadsLenHolder = $procThreadsLen - 1
		Write-Output "name=Custom Metrics | Process Monitor | $procInstance | $procVarName | thread count,value=$procThreadsLen"
		
		$h=0	
		if($procThreadsLen -gt 0)
		{
		    <# cycle through each thread of each instance of each process in the list #>
			do
			{
				<#
				$procThreadsState = $procThreads[$h].threadState
				Write-Output "name=Custom Metrics|$procVarName|Thread number $h|Thread state,value=$procThreadsState"
				
			
				$procTPT = $procThreads[$h].TotalProcessorTime
				$procTPT = $procTPT
				Write-Output "name=Custom Metrics|$procVarName|Thread number $h|Total Processor TIme,value=$procTPT"
			
				$procUPT = $procThreads[$h].UserProcessorTime
				$procUPT = $procUPT
				Write-Output "name=Custom Metrics|$procVarName|Thread number $h|User Processor Time,value=$procUPT"
				#>
			
				$h++
			}
			while($h -le $procThreadsLenHolder)
		}	
		$z++
	}
	while($z -le $lenPerProc)
		
$i++		
}
while($i -le $len)
