%dw 2.0
output application/json

var upPayload = payload  map ((item, index) -> item ++ "ItemCode": item.ItemNumber ++  item.LocationID)
var upKzo = KzooInventoryTable  map ((item, index) -> item ++ "ItemCode": item.ItemNumber ++  item.LocationID)

fun findKzoRecord(itemCode) = upKzo filter ((item) -> item.ItemCode == itemCode)
---

//find the record -- compare qtys -- validates qtys --- output
(upPayload map ((item, index) -> {
    outItem: if(flatten(findKzoRecord(item.ItemCode) map ([$.QtyonHand != item.QtyonHand, $.QtyAvailable != item.QtyAvailable, $.QtyAllocated != item.QtyAllocated] )) contains  true) item  else []
    
})).outItem filter ($ != [] )

