#region Jobs

# Part 1: Spawning unbound new jobs
$machines = 1..100 | ForEach-Object {'NODE{0:d3}' -f $_}
$jobs = Invoke-Command -ComputerName $machines -AsJob -ScriptBlock {
    Get-WinEvent -FilterHashtable @{
        LogName = 'System'
        ID = 1014
    } -MaxEvents 50
}

#endregion

#region Runspaces

#endregion

#region Additional cmdlets

# Sample from github.com/nightroman/SplitPipeline
Measure-Command { 1..10 | . {process{ $_; sleep 1 }} }
Measure-Command { 1..10 | Split-Pipeline {process{ $_; sleep 1 }} }
Measure-Command { 1..10 | Split-Pipeline -Count 10 {process{ $_; sleep 1 }} }

# A practical example: Hash calculation
Measure-Command { Get-ChildItem -Path $PSHome -File -Recurse | Get-FileHash } #2.3s
Measure-Command { Get-ChildItem -Path $PSHome -File -Recurse | Split-Pipeline {process{Get-FileHash -Path $_.FullName}} } # 0.6s

#endregion