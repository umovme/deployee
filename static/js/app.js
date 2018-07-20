var apiPrefix = '/api';

var app = new Vue({
    el: '#app',
    data() {
        return {
            asGroups: [],
            regions: [],
            regionSelected: "",
            isLoading: true
        }
    },
    created() {
        axios
            .get(`${apiPrefix}/regions`)
            .then(response => (this.regions = response.data))
    },
    watch: {
        regions(region) {
            this.regionSelected = region[0].name
        },
        regionSelected(region) {
            this.isLoading = true
            const vm = this
            axios
                .get(`${apiPrefix}/groups?region=${region}`)
                .then(response => {
                    this.asGroups = response.data
                    vm.isLoading = false
                })
        }
    },
    methods: {
        update(index, group) {
            const vm = this

            axios
                .put(`${apiPrefix}/groups/${group.name}`, group)
                .then((response) => {

                    vm.$set(vm.asGroups, index, response.data)

                })
                .catch((error) => {
                    swal({
                        type: 'error',
                        imageUrl: '/ui/images/xanaina.jpg',
                        text: `${error.response.data}`,
                        showConfirmButton: true,
                    })
                });
        }
    }
})
