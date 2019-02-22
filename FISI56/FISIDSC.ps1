Configuration JEAFISI
{
    Import-DscResource -Module JustEnoughAdministration, PSDesiredStateConfiguration
     File ModuleJEA
    {
        SourcePath = "\\HD-CL1.gfn-training.de\FISIJEA\ModuleJEA"
        DestinationPath = "C:\Program Files\WindowsPowerShell\Modules\ModuleJEA"
        Checksum = "SHA-256"
        Ensure = "Present"
        Type = "Directory"
        Recurse = $true
    }
     JeaEndpoint JEAMaintenanceEndpoint
    {
        EndpointName = "gfn-training.fisi"
        RoleDefinitions = @{ 'gfn-training\FisiAdmin' = @{ RoleCapabilities = 'FISIJEARole' }}
        TranscriptDirectory = 'C:\Transcripts'
        DependsOn = '[File]ModuleJEA'
    }
}

JEAFISI -outputpath C:\TEMP
Start-DscConfiguration -Path c:\temp