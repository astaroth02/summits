'use strict';

const controller = require('./controller');

module.exports = function(app) {
    app.get('/about', controller.about);
    app.post('/ascent', controller.createAscent);
    app.get('/ascent/findBySummit/:summitId', controller.getAscentsBySummit);
    app.get('/ascent/findByUser/:username', controller.getAscentsByUser);
    app.route('/ascent/:ascentId')
        .get(controller.getAscent)
        .delete(controller.deleteAscent);
};
