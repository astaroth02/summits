'use strict'

const matterhorn = {
  id: 1,
  name: 'Matterhorn',
  height: 4478,
  country: 'Switzerland'
}

const montBlanc = {
  id: 2,
  name: 'Mont Blanc',
  height: 4810,
  country: 'France'
}

const schauinsland = {
  id: 3,
  name: 'Schauinsland',
  height: 1284,
  country: 'Germany'
}

const feldberg = {
  id: 4,
  name: 'Feldberg',
  height: 1493,
  country: 'Germany'
}

const damavand = {
  id: 5,
  name: 'Damavand',
  height: 5610,
  country: 'Iran'
}

const k2 = {
  id: 6,
  name: 'K2',
  height: 8611,
  country: 'China'
}

const mounteverest = {
  id: 7,
  name: 'Mount Everest',
  height: 8848,
  country: 'Nepal'
}

const zugspitze = {
  id: 8,
  name: 'Zugspitze',
  height: 2962,
  country: 'Germany'
}

const olympusmons = {
  id: 9,
  name: 'Olympus Mons',
  height: 26400,
  country: 'Mars'
}

const grossglockner = {
  id: 10,
  name: 'Großglockner',
  height: 3798,
  country: 'Austria'
}


const repository = (db) => {
  //const collection = db.collection('summits')
  const collection = [matterhorn, montBlanc, schauinsland, feldberg, damavand, k2, mounteverest, zugspitze, olympusmons, grossglockner]

  const getSummitById = (id) => {
    return new Promise((resolve, reject) => {
      resolve(collection.find(x => x.id === convertStringToInt(id)))
    })
  }

  const findSummitsByCountry = (country) => {
    return new Promise((resolve, reject) => {
      // const movies = []
      // const cursor = collection.find({}, {title: 1, id: 1})
      // const addMovie = (movie) => {
      //   movies.push(movie)
      // }
      // const sendMovies = (err) => {
      //   if (err) {
      //     reject(new Error('An error occured fetching all movies, err:' + err))
      //   }
      //   resolve(movies.slice())
      // }
      // cursor.forEach(addMovie, sendMovies)
        console.log(country)
      resolve(collection.find(x => x.country === country))
    })
  }

  const findSummitsByHeight = (height, rel) => {
    return new Promise((resolve, reject) => {
      // const movies = []
      // const cursor = collection.find({}, {title: 1, id: 1})
      // const addMovie = (movie) => {
      //   movies.push(movie)
      // }
      // const sendMovies = (err) => {
      //   if (err) {
      //     reject(new Error('An error occured fetching all movies, err:' + err))
      //   }
      //   resolve(movies.slice())
      // }
      // cursor.forEach(addMovie, sendMovies)
      resolve(collection.find(x => x.height === convertStringToInt(height)))
    })
  }

  const disconnect = () => {
    // db.close()
  }



  return Object.create({
    getSummitById,
    findSummitsByCountry,
    findSummitsByHeight,
    disconnect
  })

}

const convertStringToInt = (stringToParse) => {
    return parseInt(stringToParse)
}

const connect = (connection) => {
  return new Promise((resolve, reject) => {
    if (!connection) {
      reject(new Error('connection db not supplied!'))
    }
    resolve(repository(connection))
  })
}

module.exports = Object.assign({}, {connect})
