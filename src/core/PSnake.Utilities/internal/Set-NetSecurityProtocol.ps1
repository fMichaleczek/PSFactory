function Set-NetSecurityProtocol 
{
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding(SupportsShouldProcess = $false)]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Set')]
        [System.Net.SecurityProtocolType]
        $Type = [System.Net.SecurityProtocolType]::Tls2,

        [Parameter(Mandatory, ParameterSetName = 'Revert')]
        [switch]
        $Revert
    )

    switch ($PSCmdlet.ParameterSetName) 
    {
        'Set' 
        {
            $Script:OriginalSecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor $Type
        }
        
        'Revert'
        {
            if ($Script:OriginalSecurityProtocol) 
            {
                [System.Net.ServicePointManager]::SecurityProtocol = $Script:OriginalSecurityProtocol
                Remove-Variable -Name OriginalSecurityProtocol -Scope Script -Force
            }
            else
            {
                Write-Warning 'No Net Security Protocol to revert'
            }
        }
    }
    
}