import L from "leaflet";

class StoreMap {
    constructor(element, center, markerClickedCallback) {
        this.map = L.map(element).setView(center, 13);
        const accessToken = "pk.eyJ1IjoiZ3V1aG9saSIsImEiOiJja2c5bWVuaGwwc281MnNwZ3RtMjVlaWFuIn0.c8uUwyoB-wHJnrPEotEGSw"

        L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
            attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
            maxZoom: 18,
            id: 'mapbox/streets-v11',
            tileSize: 512,
            zoomOffset: -1,
            accessToken: accessToken
        }).addTo(this.map);
        this.markerClickedCallback = markerClickedCallback;
    }

    addMarker(store) {
        const marker = L.marker([store.lat, store.lng], {
                storeID: store.id
            })
            .addTo(this.map)
            .bindPopup(
                `
                    <p>${store.name}</p>
                    <a href="https://maps.google.com/?q=${store.lat},${store.lng}" target="_blank">ir ate o local</a>
                `
                );

        marker.on("click", e => {
            marker.openPopup();
            this.markerClickedCallback(e)
        })

        return marker;
    }

    highlightMarker(store) {
        const marker = this.markerForStore(store);
        marker.openPopup();
        this.map.panTo(marker.getLatLng());
    }

    markerForStore(store) {
        let markerLayer;
        this.map.eachLayer(layer => {
            if (layer instanceof L.Marker) {
                const markerPosition = layer.getLatLng();
                if (markerPosition.lat === store.lat && markerPosition.lng == store.lng) {
                    markerLayer = layer;
                }
            }
        })
        return markerLayer;
    }

}

export default StoreMap;