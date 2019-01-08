
# auxiliary function generating the REST API header

function Get-AdminApiHeaders {
Param(
    $apiUrl
)

# Add .NET Framework type to handle the IIS Adminstration API untrusted certificate
If (-not ('ITrustACertificatePolicy' -as [type]))
{
Add-Type @" 
using System.Net; 
using System.Security.Cryptography.X509Certificates; 
public class ITrustACertificatePolicy : ICertificatePolicy { 
    public ITrustACertificatePolicy() {} 
    public bool CheckValidationResult( 
       ServicePoint sPoint, X509Certificate cert, 
       WebRequest wRequest, int certProb) { 
            return true;
       } 
} 
"@
}

# Instantiate the ITrustACerificatePolicy in the current session
[System.Net.ServicePointManager]::CertificatePolicy = New-Object ITrustACertificatePolicy

$iisAdminApiResp1 = Invoke-WebRequest -Uri "$apiUrl/security/api-keys" `
				      -UseDefaultCredentials `
                                      -SessionVariable session 

$xsrfTokenHeader = $iisAdminApiResp1.Headers."XSRF-TOKEN"
$xsrfTokenHash = @{}
$xsrfTokenHash."XSRF-TOKEN" = $xsrfTokenHeader

$iisAdminApiResp2 = Invoke-WebRequest -Uri "$apiUrl/security/api-keys" `
                                      -UseDefaultCredentials `
				      -Headers $xsrfTokenHash `
				      -Method Post `
				      -ContentType "application/json" `
                                      -WebSession $session `
				      -Body '{"expires_on": ""}'

$resp2Content = ConvertFrom-Json ([System.Text.Encoding]::UTF8.GetString($iisAdminApiResp2.content))
$accessToken = $resp2Content.access_token
$accessTokenHash = @{}
$accessTokenHash."Access-Token" = "Bearer $accessToken"
$accessTokenHash."Accept" = "application/hal+json"

return $accessTokenHash

} #end function Get-AdminApiHeaders

$computerName = 'lon-svr1.adatum.com'
$apiUrl = "https://$($computerName):55539"
$headers = Get-AdminApiHeaders -apiUrl $apiUrl

Write-Output -PSObject $headers




############## Beginning of the demo ##################
# enumerate existing web sites and app pools on LON-SVR1
#######################################################

$iisAdminApiWebSites = Invoke-RestMethod -Uri "$apiUrl/api/webserver/websites" `
                                      	 -UseDefaultCredentials `
					 -Headers $headers `
					 -Method Get `
					 -ContentType "application/json"

$iisAdminApiWebSites | ConvertTo-Json

$iisAdminApiAppPools = Invoke-RestMethod -Uri "$apiUrl/api/webserver/application-pools" `
					 -UseDefaultCredentials `
					 -Headers $headers `
                                      	 -Method Get `
					 -ContentType "application/json" 

$iisAdminApiAppPools | ConvertTo-Json


############## Beginning of Lab B Task 2 ##############
# create a new web site WebSite1 (port 8081) on SVR1
#######################################################

$siteName = 'WebSite1'
$portNumber = '8081'

If ($iisAdminApiWebSites.websites[-1].name -ne "$siteName") {
	Invoke-Command -ComputerName $computerName -ScriptBlock {
	New-Item -Path "C:\inetpub\$using:siteName" -ItemType Directory -Force
	}       
$newSite = @"
{
        "name": "$sitename",
        "physical_path": "%SystemDrive%\\inetpub\\$sitename",
        "bindings": [
            {
                "protocol": "http",
                "ip_address": "*",
                "port":"$portNumber"
            }
		]
}		
"@

$iisAdminApiNeWSites = Invoke-RestMethod -Uri "$apiUrl/api/webserver/websites" `
                                         -UseDefaultCredentials `
                                         -Headers $headers `
                                         -Method Post `
                                         -ContentType "application/json" `
                                    	 -Body $newSite
    
$iisAdminApiNewSites| ConvertTo-Json

}


#region Virtual Directory erstellen

############## Beginning of Lab B Task 3 ##############
# create a new virtual directory for site01 on LON-SVR1
#######################################################

$vdirName = 'vdir01'

$iisAdminApiWebSites = Invoke-RestMethod -Uri "$apiUrl/api/webserver/websites" `
                                      	 -UseDefaultCredentials `
					 -Headers $headers `
					 -Method Get `
					 -ContentType "application/json" 

$webSiteId = $iisAdminApiWebSites.websites[-1].id

$iisAdminApiWebApp = Invoke-RestMethod -Uri "$apiUrl/api/webserver/webapps?website.id=$webSiteId" `
				       -UseDefaultCredentials `
				       -Headers $headers `
				       -Method Get `
				       -ContentType "application/json" 

$webAppId = $iisAdminApiWebApp.webapps.id

Invoke-Command -ComputerName $computerName -ScriptBlock {
	New-Item -Path "C:\inetpub\$using:vdirName" -ItemType Directory -Force
}

$newVDir = @"
    { "location":"$siteName/",
      "path":"/$vdirName",
      "physical_path": "%SystemDrive%\\inetpub\\$vdirName",
      "webapp": {
        "id": "$webAppId"
      }
    }
"@;

$vDirs = Invoke-RestMethod -Uri "$apiUrl/api/webserver/virtual-directories?website.id=$websiteId" `
			   -UseDefaultCredentials `
			   -Headers $headers `
			   -Method Get `
			   -ContentType "application/json" 


If ($vDirs.virtual_directories.location[-1] -ne "$siteName/$vdirName") {

 $iisAdminApiNewVDir = Invoke-WebRequest -Uri "$apiUrl/api/webserver/virtual-directories/$($vDirs.virtual_directories.id)" `
					-UseDefaultCredentials `
					-Headers $headers `
                                	-Method Post `
					-ContentType "application/json" `
	                                -Body $newVDir

 $iisAdminApiNewVDir | ConvertTo-Json
}

#endregion