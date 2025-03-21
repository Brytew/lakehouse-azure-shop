# PowerShell to create a data lake: storage account, namespace

# create namespace = "Silver"
$NAMESPACE = "silver"
$STORAGEACCOUNTNAME = "projonestorageaccount"  
az storage fs create -n $NAMESPACE --account-name $STORAGEACCOUNTNAME --metadata project=lakehouse-azure-shop environment=development layer=bronze --only-show-errors
