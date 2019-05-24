const uuidv4 = require('uuid/v4');

const Store = require('data-store');
const store = new Store({ path: `${__dirname}/config.json` });


module.exports = {
  save: user => {
    store.set(user.username, {...user, id: uuidv4()} );
    console.log(`Added ${user.username}`);
  },
  get: username => {
    console.log(username)
    return store.get(username)
  },
  update: (username, user) => {
    const getUser = store.get(username);
    store.set(username, {...getUser, ...user});
  },
  delete: (username) => {
   store.del(username); 
  }

}

