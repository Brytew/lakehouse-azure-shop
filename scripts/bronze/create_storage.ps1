# PowerShell to create a data lake: storage account, namespace

# create storage account -> data lake -> hns True (Hierarchical namespace)
$STORAGEACCOUNTNAME = "projonestorageaccount"
$RESOURCEGROUPNAME = "projOne"
$LOCATION = "polandcentral"
az storage account create --name $STORAGEACCOUNTNAME --resource-group $RESOURCEGROUPNAME --kind StorageV2 --location $LOCATION --hns true --sku Standard_LRS --tags #owner=XX environment=development


# create namespace = "Bronze"
$NAMESPACE = "bronze"
$STORAGEACCOUNTNAME = "projonestorageaccount"  
az storage fs create -n $NAMESPACE --account-name $STORAGEACCOUNTNAME --metadata project=lakehouse-azure-shop environment=development layer=bronze --only-show-errors
