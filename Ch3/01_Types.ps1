"String"
[System.DateTime] "24/08/2018"

"String".GetType()
([System.DateTime] "24/08/2018").GetType()

Get-Member -InputObject "String"

# List of the commonly used types:
# sequence of UTF-16 code units.
[String] sequence of UTF-16 code units.
# character as a UTF-16 code unit.
[Char] A Unicode 16-bit character
# 8-bit unsigned integer.
[Byte] An 8-bit unsigned character

# 32-bit signed integer
[Int] 
#64-bit signed integer
[Long] 
# 128-bit decimal value
[Decimal]
# Single-precision 32-bit floating point number 
[Single] 
# Double-precision 64-bit floating point number
[Double] 

# Boolean - can be $True or $False
[Bool] 

#.NET class, which holds the combination of date and time
[DateTime] Date and Time

# A XML-Object - can be greatly used to store and load configuratio data.
[XML] 

# An array of different values
[Array] 
 
# Hashtable is an associative array, which maps keys to values.
[Hashtable] Hashtable object

#region Generics

[System.Collections.Generic.Dictionary]

#endregion