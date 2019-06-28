const uuidv4 = require('uuid/v4');

const Store = require('data-store');
const store = new Store({ path: `${__dirname}/config.json` });
const log_Prefix = 'summits-application: '


module.exports = {
  save: user => {
    store.set(user.username, {...user, id: uuidv4()} );
    console.log(log_Prefix + `User-service : Added ${user.username}`);
  },
  get: username => {
    console.log(log_Prefix + `User-service: get user with username: ${username}`);
    return store.get(username)
  },
  update: (username, user) => {
    console.log(log_Prefix + `User-service: update user with username: ${username}`);
    const getUser = store.get(username);
    store.set(username, {...getUser, ...user});
  },
  delete: (username) => {
  console.log(log_Prefix + `User-service: delete user with username: ${username}`);
   store.del(username); 
  }

}

