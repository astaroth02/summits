'use strict';

const properties = require('../../package.json')
const user = require('../model/user');
//var distance = require('../service/distance');

const user1 = {
    id: 1,
    username: "frank.rittinger",
    firstName: "Frank",
    lastName: "Rittinger",
    email: "frank@schnegg.net",
    password: "xxx",
    userStatus: "approved"
}


const controllers = {
    about: function(req, res) {
        const aboutInfo = {
            name: properties.name,
            version: properties.version
        }
        res.json(aboutInfo);
    },
    createUser: function(req, res) {
        user.save(req.body);
        res.json(req.body);
    },
    getUser: function(req, res) {
        const result = user.get(req.params.username);
        res.json(result);
    },
    deleteUser: function(req, res) {
        user.delete(req.params.username);
        res.send(req.params.username)
    },
    updateUser: function(req, res) {
        user.update(req.params.username, req.body);
        res.json(req.body);
    },
    
    // get_distance: function(req, res) {
    //     distance.find(req, res, function(err, dist) {
    //         if (err)
    //             res.send(err);
    //         res.json(dist);
    //     });
    // },
};

module.exports = controllers;
