'use strict';

const request = require('request');
const properties = require('../../package.json')
//var distance = require('../service/distance');
const log_Prefix = 'summits-application: '

const ascentSki = {
    id: 1,
    summitId: 2,
    userId: 2,
    ascentDate: "2019-04-01",
    status: "success",
    tourType: "ski"
}
const ascentHike = {
    id: 2,
    summitId: 1,
    userId: 2,
    ascentDate: "2019-08-01",
    status: "success",
    tourType: "hike"
}

const controllers = {
    about: function(req, res) {
        const aboutInfo = {
            name: properties.name,
            version: properties.version
        }
        res.json(aboutInfo);
    },
    createAscent: function(req, res) {
        console.log(log_Prefix + req.body);
        res.json(req.body);
    },
    getAscent: function(req, res) {
        res.json(ascentSki);
    },
    deleteAscent: function(req, res) {
        res.send(req.params)
    },
    getAscentsByUser: function(req, res) {
        console.log(log_Prefix + `Ascent-service: getAscentsByUser. username: ${req.params.username}`);
        const userServiceHost = process.env.SUMMITS_USER_SERVICE_SERVICE_HOST;
        const userServicePort = process.env.SUMMITS_USER_SERVICE_SERVICE_PORT;
        const url = 'http://' + userServiceHost + ':' + userServicePort + '/user/' + req.params.username;
        console.log(log_Prefix + url);
        request( url, { json: true }, (err, innerRes, body) => {
            if (!err && innerRes.statusCode == 200) {
                console.log(log_Prefix + '# response status: ' + innerRes.statusCode);
                console.log(log_Prefix + '# Ascent Service: email=%s', body.email);
                res.json({user : body, ascent : [ascentSki, ascentHike]});

            } else {
                console.log(log_Prefix + err);
                res.sendStatus(500);
            }
        });
    },
    getAscentsBySummit: function(req, res) {
        console.log(log_Prefix + `Ascent-service: getAscentsBySummit. id ${req.params.summitId}`);
        const summitsServiceHost = process.env.SUMMITS_GENERAL_SERVICE_SERVICE_HOST;
        const summitsServicePort = process.env.SUMMITS_GENERAL_SERVICE_SERVICE_PORT;
        const url = 'http://' + summitsServiceHost + ':' + summitsServicePort + '/summit/' + req.params.summitId;
        console.log(log_Prefix + url);
        request( url, { json: true }, (err, innerRes, body) => {
            if (!err && innerRes.statusCode == 200) {
                console.log(log_Prefix + '# response status: ' + innerRes.statusCode);
                console.log(log_Prefix + '# Ascent Service: country=%s', body.country);
                res.json({summit : body, ascent : [ascentSki, ascentHike]});

            } else {
                console.log(log_Prefix + err);
                res.sendStatus(500);
            }
        });
    }
    // get_distance: function(req, res) {
    //     distance.find(req, res, function(err, dist) {
    //         if (err)
    //             res.send(err);
    //         res.json(dist);
    //     });
    // },
};

module.exports = controllers;
