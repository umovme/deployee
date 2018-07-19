var apiPrefix = '/api';

var app = new Vue({
    el: '#app',
    data() {
        return {
            asGroups: [],
            regions: [],
            regionSelected: ""
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
            axios
                .get(`${apiPrefix}/groups?region=${region}`)
                .then(response => (this.asGroups = response.data))
        }
    },
    methods: {
        update(index, group) {
            const vm = this
            group.isUpdating = true
            vm.$set(vm.asGroups, index, group)
            axios
                .put(`${apiPrefix}/groups/${group.name}`, group)
                .then((response) => {

                    vm.$set(vm.asGroups, index, response.data)

                    swal({
                        type: 'success',
                        title: 'Xae! Xae!',
                        imageUrl: '/ui/images/xae.jpg',
                        text: `${group.name} foi ajustado com sucesso.`,
                        showConfirmButton: false,
                        timer: 2500
                    })
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
