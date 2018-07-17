var apiPrefix = '/api/groups';

var app = new Vue({
  el: '#app',
  data() {
    return {
      asGroups : []
    }
  },
  mounted() {
    axios
      .get(apiPrefix)
      .then(response => (this.asGroups = response.data))
  },
  methods: {
    update(index, group) {
      console.log(group)
      // debugger
      const vm = this
      axios
        .put(`${apiPrefix}/${group.name}`, group)
        .then((response) => {

          vm.$set(vm.asGroups, index, response.data)
          // console.log(response);

          swal({
            // position: 'top-end',
            type: 'success',
            title: 'Deu certo!',
            text: `${group.name} foi ajustado com sucesso.`,
            showConfirmButton: false,
            timer: 2500
          })
        })
        .catch((error) => {
          // Error
          if (error.response) {
              // The request was made and the server responded with a status code
              // that falls out of the range of 2xx
              console.log(error.response.data);
              console.log(error.response.status);
              console.log(error.response.headers);
          } else if (error.request) {
              // The request was made but no response was received
              // `error.request` is an instance of XMLHttpRequest in the browser and an instance of
              // http.ClientRequest in node.js
              console.log(error.request);
          } else {
              // Something happened in setting up the request that triggered an Error
              console.log('Error', error.message);
          }
          console.log(error.config);

          swal({
            // position: 'top-end',
            type: 'error',
            // title:
            title: error.message,
            text: `${error.response.data}`,
            showConfirmButton: true,
            // timer: 2500
          })
  });
    }
  }
})
