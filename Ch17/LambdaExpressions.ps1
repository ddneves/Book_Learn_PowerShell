#requires -Version 3
 
# Ast parameter validation is used to ensure that the lambda
# function passed in has either one or two parameters.
 
function Map-Sequence
{
    param (
        [Parameter(Mandatory=$true,HelpMessage='Add help message for user')]
        [ValidateScript({ $_.Ast.ParamBlock.Parameters.Count -eq 1 })]
        [Scriptblock] $Expression,
 
        [Parameter(Mandatory=$true,HelpMessage='Add help message for user')]
        [ValidateNotNullOrEmpty()]
        [Object[]] $Sequence
    )
 
    $Sequence | ForEach-Object { &$Expression $_ }
}
 
function Reduce-Sequence
{ 
    param (
        [Parameter(Mandatory=$true,HelpMessage='Add help message for user')]
        [ValidateScript({ $_.Ast.ParamBlock.Parameters.Count -eq 2 })]
        [Scriptblock] $Expression,
 
        [Parameter(Mandatory=$true,HelpMessage='Add help message for user')]
        [ValidateNotNullOrEmpty()]
        [Object[]] $Sequence
    )
 
    $AccumulatedValue = $Sequence[0]
 
    if ($Sequence.Length -gt 1)
    {
        $Sequence[1..($Sequence.Length - 1)] | ForEach-Object {
            $AccumulatedValue = &$Expression $AccumulatedValue $_
        }
    }
 
    $AccumulatedValue
}
 
function Filter-Sequence
{   
    param (
        [Parameter(Mandatory=$true,HelpMessage='Add help message for user')]
        [ValidateScript({ $_.Ast.ParamBlock.Parameters.Count -eq 1 })]
        [Scriptblock] $Expression,
 
        [Parameter(Mandatory=$true,HelpMessage='Add help message for user')]
        [ValidateNotNullOrEmpty()]
        [Object[]] $Sequence
    )
 
    $Sequence | Where-Object { &$Expression $_ -eq $True }
}

$IntArray = @(1, 2, 3, 4, 5, 6)
 
$Double = { param($x) $x * 2 }
$Sum = { param($x, $y) $x + $y }
$Product = { param($x, $y) $x * $y }
$IsEven = { param($x) $x % 2 -eq 0 }
 
Map-Sequence -Expression $Double -Sequence $IntArray
Reduce-Sequence -Expression $Sum -Sequence $IntArray
Reduce-Sequence -Expression $Product -Sequence $IntArray
Filter-Sequence -Expression $IsEven -Sequence $IntArray


#http://www.powershellmagazine.com/2013/12/23/simplifying-data-manipulation-in-powershell-with-lambda-functions/