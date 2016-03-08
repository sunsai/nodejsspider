request = require('superagent')
cheerio = require('cheerio')
http=require('http')
a=[1..11]
spider = (url)->
  request.get(url).end((err, res)->
    if !err
      $ = cheerio.load(res.text)
      #    console.log($('.index-item div a'))
      $('#list_article .single_fake div div a').each(->
        console.log(url)
        console.log("   title:"+$(this).attr('title'))
        console.log("   href:"+$(this).attr('href'))
        console.log("   text:"+$(this).text())
#        console.log($(this).attr('title') + ':http://www.tuicool.com/' + $(this).attr('href'))
        console.log("=======================================1====")
      )
    else
      console.log('err')
  )
spider 'http://www.tuicool.com/ah/0/' + item.toString() + '?lang=1' for item in[0..30]
