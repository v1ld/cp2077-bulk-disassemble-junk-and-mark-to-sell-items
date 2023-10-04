@replaceMethod(BackpackMainGameController)
private final func RefreshUI() -> Void {
    this.PopulateInventory();
    this.SetupDisassembleButtonHints();
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnHandleGlobalInput");
}


@addMethod(BackpackMainGameController)
private final func DisassembleJunkItems() -> Void {
    let junkItems: array<InventoryItemData> = this.m_InventoryManager.GetPlayerItemsByType(gamedataItemType.Gen_Junk);
    for itemData in junkItems {
        ItemActionsHelper.DisassembleItem(this.m_player, InventoryItemData.GetID(itemData), InventoryItemData.GetQuantity(itemData));
    }
}

@addMethod(BackpackMainGameController)
private final func DisassembleMarkToSellItems() -> Void {
    let markedItems: array<wref<gameItemData>>;
    this.m_InventoryManager.GetPlayerItemsMarkedToSell(markedItems);
    for itemData in markedItems {
        ItemActionsHelper.DisassembleItem(this.m_player, itemData.GetID(), itemData.GetQuantity());
    }
}

@addMethod(BackpackMainGameController)
private final func HaveJunkOrMarkedItemsToDisassemble() -> Bool {
    let junkItems: array<InventoryItemData> = this.m_InventoryManager.GetPlayerItemsByType(gamedataItemType.Gen_Junk);
    let markedItems: array<wref<gameItemData>>;
    this.m_InventoryManager.GetPlayerItemsMarkedToSell(markedItems);

    return ArraySize(junkItems) > 0 || ArraySize(markedItems) > 0;
}

@addMethod(BackpackMainGameController)
protected cb func OnHandleGlobalInput(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"world_map_menu_cycle_filter_prev") {
        this.DisassembleJunkItems();
        this.DisassembleMarkToSellItems();
        this.PlaySound(n"Item", n"OnBuy");
    }
}

@addMethod(BackpackMainGameController)
private final func SetupDisassembleButtonHints() -> Void {
    if this.HaveJunkOrMarkedItemsToDisassemble() {
        this.m_buttonHintsController.AddButtonHint(n"world_map_menu_cycle_filter_prev", GetLocalizedText("UI-ScriptExports-Disassemble0") + " Trash");
    } else {
        this.m_buttonHintsController.RemoveButtonHint(n"world_map_menu_cycle_filter_prev");
    }
}

