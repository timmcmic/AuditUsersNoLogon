Install-module Microsoft.Graph.Reports
Install-module Microsoft.Graph.User

Connect-MGGraph -scopes User.Read.All,AuditLog.Read.All

#(Note consent may be required if you have not utilized these graph scopes for the user being specified on logon.)

$events = Get-MgAuditLogSignIn -All  #(This command pulls all the events from the audit logs for the last 30 days)

$successEvents = $events | where {$_.status.errorCode -eq 0}  #(This command pulls all of the events from the audit logs for the last 30 days)

$uniqueSuccessEvents = $successEvents | sort-object -property UserPrincipalName -unique

#The final variable here contains a list of user principal names that have signed into the environment and were successful.  Your’re request is for accounts that have not signed in.

$users = get-MGUser -all  #(Get all of the users into a variable).

Foreach ($successEvent in $uniqueSuccessEvents)
{
              If ($users.userPrincipalName -contains $successEvent.userPrincipalName)
              {
                           $users = $users | where {$_.userPrincipalName -ne $succesEvent.UserPrincipalName
              }
}

$users = export-csv c:\temp\noLogon.export-csv