import LineChart from "./charts/line-chart"
const ChartTest = {
    mounted() {
        const {labels, values} = JSON.parse(this.el.dataset.chartData);
        this.chart = new LineChart(this.el, labels, values)
        this.handleEvent("new-point", ({label, value}) => {
            this.chart.addPoint(label, value)
        })
    },
    updated() {

    },
    destroyed() {

    }
}

export default ChartTest;