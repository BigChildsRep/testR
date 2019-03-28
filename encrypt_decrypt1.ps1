function Decrypt-Text
{
  
  param
  (
    [String]
    [Parameter(Mandatory,ValueFromPipeline)]
    $EncryptedText
  )
  process
  {
    $secureString = $EncryptedText | ConvertTo-SecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString)
    [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
  }
}
 
function Encrypt-Text
{
  
  param
  (
    [String]
    [Parameter(Mandatory,ValueFromPipeline)]
    $Text
  )
  process
  {
     $Text |
       ConvertTo-SecureString -AsPlainText -Force |
       ConvertFrom-SecureString
  }
}
$anton =read-host -AsSecureString
$anton|ConvertFrom-SecureString|decrypt-text


'PowerShell Rocks' | Encrypt-Text
'Hello, World!' | Encrypt-Text | Decrypt-Text 
