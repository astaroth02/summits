const uuidv4 = require('uuid/v4');

const Store = require('data-store');
const store = new Store({ path: `${__dirname}/config.json` });


module.exports = {
  save: user => {
    store.set(user.username, {...user, id: uuidv4()} );
    console.log(`User-service : Added ${user.username}`);
  },
  get: username => {
    console.log(`User-service: get user with username: ${username}`);
    return store.get(username)
  },
  update: (username, user) => {
    console.log(`User-service: update user with username: ${username}`);
    const getUser = store.get(username);
    store.set(username, {...getUser, ...user});
  },
  delete: (username) => {
  console.log(`User-service: delete user with username: ${username}`);
   store.del(username); 
  }

}

