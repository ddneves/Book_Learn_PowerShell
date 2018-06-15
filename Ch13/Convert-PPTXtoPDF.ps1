<#
    .NOTES
    ===========================================================================
    Created on:     18.12.2017
    Created by:     David das Neves, PFE
    Project:        Tools
    Customer:       Microsoft         
    Organization:   Microsoft Germany GmbH
    Filename:       Convert-PPTXtoPDF.ps1

    ===========================================================================
    .DESCRIPTION
    Converts Powerpoint files to pdf.

    .DISCLAIMER
    THIS CODE-SAMPLE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER 
    EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES 
    OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.

    This sample is not supported under any Microsoft standard support program 
    or service. The script is provided AS IS without warranty of any kind. 
    Microsoft further disclaims all implied warranties including, without 
    limitation, any implied warranties of merchantability or of fitness for a 
    particular purpose. The entire risk arising out of the use or performance
    of the sample and documentation remains with you. In no event shall 
    Microsoft, its authors, or anyone else involved in the creation, 
    production, or delivery of the script be liable for any damages whatsoever 
    (including, without limitation, damages for loss of business profits, 
    business interruption, loss of business information, or other pecuniary 
    loss) arising out of the use of or inability to use the sample or 
    documentation, even if Microsoft has been advised of the possibility of 
    such damages.
#>


<#
    .Synopsis
    Convert PowerPoint files to pdf.
    .DESCRIPTION
    Convert PowerPoint files to pdf. Searches recursively in complete folders.
    .EXAMPLE
    Convert-PPTXtoPDF -Path c:\Workshops\
#> 
function Convert-PPTXtoPDF
{ 
  [CmdletBinding()]
  Param
  (
    # Folder or File
    [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true,
    Position = 0)]
    $Path  
  )
  #Load assembly.
  $null = Add-Type -AssemblyName Microsoft.Office.Interop.PowerPoint
  
  #Store SaveOption
  $SaveOption = [Microsoft.Office.Interop.PowerPoint.PpSaveAsFileType]::ppSaveAsPDF
      
  #Open PowerPoint ComObject
  $PowerPoint = New-Object -ComObject 'PowerPoint.Application'
  
  #Retrieve all pptx elements recursively.
  Get-ChildItem $Path -File -Filter *pptx -Recurse |
  ForEach-Object -Begin {
  } -Process {
    #create a pdf file for each found pptx file
    $Presentation = $PowerPoint.Presentations.Open($_.FullName)
    $PdfNewName  = $_.FullName -replace '\.pptx$', '.pdf'
    $Presentation.SaveAs($PdfNewName,$SaveOption)
    $Presentation.Close()
  } -End {
    #Close Powerpoint after the last conversion 
    $PowerPoint.Quit()
    
    #Kill process
    Stop-Process -Name POWERPNT -Force
  }
}
