const ScrollStores = {
    mounted(){
        console.log("mounted", this.el)
        this.observer = new IntersectionObserver(entries => {
            console.log(entries)
            const entry = entries[0];
            if(entry.isIntersecting){
                // console.log("visible")
                this.pushEvent("load-stores", {})
            }
        })
        this.observer.observe(this.el)
    },
    updated(){
        const pageNumber = this.el.dataset.pageNumber;
        console.log("updated", pageNumber)
    },
    destroyed(){
        this.observer.disconnect();
    }
}

export default ScrollStores;