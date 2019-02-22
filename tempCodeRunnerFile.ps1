Configuration JEAFISI
{
    Import-DscResource -Module JustEnoughAdministration, PSDesiredStateConfiguration
     File ModuleJEA
    {
        SourcePath = "\\HD-DC1.adatum.com\JEA\ModuleJEA"
        DestinationPath = "C:\Program Files\WindowsPowerShell\Modules\JEAFISI"
        Checksum = "SHA-256"
        Ensure = "Present"
        Type = "Directory"
        Recurse = $true
    }
     JeaEndpoint JEAMaintenanceEndpoint
    {
        EndpointName = "gfn-training.fisi"
        RoleDefinitions = @{ 'gfn-training\FisiAdmins' = @{ RoleCapabilities = 'FISIJEARole' }}
        TranscriptDirectory = 'C:\Transcripts'
        DependsOn = '[File]ModuleJEA'
    }
}
