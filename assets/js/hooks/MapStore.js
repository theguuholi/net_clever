import StoreMap from "./map_store/store-map";

const MapStore = {
    mounted() {
        this.map = new StoreMap(this.el, [-22.74639202136818, -47.34120244169937], event => {
            console.log("abc!!!!")
            console.log(event.target.options.storeID)
            const storeId = event.target.options.storeID;
            this.pushEvent("store-clicked", {store_id: storeId})
        });

        const stores = JSON.parse(this.el.dataset.stores);
        stores.forEach(store => {
            this.map.addMarker(store);
        })

        this.handleEvent("highlight-marker", store => {
            this.map.highlightMarker(store)
        })
        this.handleEvent("add-marker", store => {
            this.map.addMarker(store)
            this.map.highlightMarker(store)
        })
    }
}

export default MapStore;