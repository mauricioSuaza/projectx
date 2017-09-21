(function() {
  var Clearbit, providePlugin,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  providePlugin = function(pluginName, pluginConstructor) {
    var tryApply = function() {
      var ga = window[window['GoogleAnalyticsObject'] || 'ga'];

      if (typeof ga === 'function') {
        ga('provide', pluginName, pluginConstructor);
        return true;
      } else {
        return false;
      }
    }

    if (tryApply()) {
      // Native support
    } else if (window.analytics && typeof window.analytics.ready === 'function') {
      // Segment support
      analytics.ready(tryApply);
    } else {
      console.error("Clearbit error: 'ga' variable not found.");
    }
  };

  Clearbit = (function() {
    function Clearbit(tracker, config) {
      this.tracker = tracker;
      this.config = config != null ? config : {};
      this.triggerEvent = bind(this.triggerEvent, this);
      this.setDimensions = bind(this.setDimensions, this);
      this.set = bind(this.set, this);
      this.done = bind(this.done, this);
      this.mapping = this.config.mapping || {};
      this.done({"ip":"181.143.49.66","domain":"digifit.eu","fuzzy":true,"company":{"id":"3f623f6d-ddd8-43be-b214-392cabfdbc24","name":"DIGIFiT","legalName":null,"domain":"digifit.eu","domainAliases":[],"url":"http://digifit.eu","site":{"url":"http://digifit.eu","title":null,"h1":null,"metaDescription":null,"metaAuthor":null,"phoneNumbers":[],"emailAddresses":[]},"category":{"sector":"Information Technology","industryGroup":"Software \u0026 Services","industry":"Internet Software \u0026 Services","subIndustry":"Internet Software \u0026 Services"},"tags":["Information Technology \u0026 Services","Technology","Mobile","B2B","B2C","Sporting Goods"],"description":"DIGIFiT develops new technologies in the field of web, mobile, gaming and wireless to make fitness easier and more fun.","foundedYear":null,"location":null,"timeZone":null,"utcOffset":null,"geo":{"streetNumber":null,"streetName":null,"subPremise":null,"city":null,"postalCode":null,"state":null,"stateCode":null,"country":null,"countryCode":null,"lat":null,"lng":null},"logo":"https://logo.clearbit.com/digifit.eu","facebook":{"handle":null},"linkedin":{"handle":"company/digifit"},"twitter":{"handle":"DIGIFiT","id":"16101494","bio":"DIGIFiT develops new technologies in the field of web, mobile, gaming and wireless to make fitness easier and more fun.","followers":96,"following":4,"location":"Amsterdam, The Netherlands","site":"http://t.co/m96M1uEnZ2","avatar":"https://pbs.twimg.com/profile_images/842535183/Logo_square_normal.gif"},"crunchbase":{"handle":null},"emailProvider":false,"type":"private","ticker":null,"phone":null,"metrics":{"alexaUsRank":null,"alexaGlobalRank":5024673,"googleRank":null,"employees":10,"employeesRange":"1-10","marketCap":null,"raised":null,"annualRevenue":null},"tech":["nginx","aws_ec2","mandrill","aws_route_53","ubuntu","google_apps"]}});
    }

    Clearbit.prototype.done = function(response) {
      if (!(response != null ? response.company : void 0)) {
        return;
      }
      this.setDimensions(response.company);
      return this.triggerEvent(response.company);
    };

    Clearbit.prototype.set = function(key, value) {
      if (key && value) {
        return this.tracker.set(key, value);
      }
    };

    Clearbit.prototype.setDimensions = function(company) {
      var ref, ref1;
      this.set(this.mapping.companyName, company.name);
      this.set(this.mapping.companyDomain, company.domain);
      this.set(this.mapping.companyType, company.type);
      this.set(this.mapping.companyTags, (ref = company.tags) != null ? ref.join(',') : void 0);
      this.set(this.mapping.companyTech, (ref1 = company.tech) != null ? ref1.join(',') : void 0);
      this.set(this.mapping.companySector, company.category.sector);
      this.set(this.mapping.companyIndustryGroup, company.category.industryGroup);
      this.set(this.mapping.companyIndustry, company.category.industry);
      this.set(this.mapping.companySubIndustry, company.category.subIndustry);
      this.set(this.mapping.companyCountry, company.geo.countryCode);
      this.set(this.mapping.companyState, company.geo.stateCode);
      this.set(this.mapping.companyCity, company.geo.city);
      this.set(this.mapping.companyFunding, company.metrics.raised);
      this.set(this.mapping.companyEmployeesRange, company.metrics.employeesRange);
      this.set(this.mapping.companyEmployees, company.metrics.employees);
      return this.set(this.mapping.companyAlexaRank, company.metrics.alexaGlobalRank);
    };

    Clearbit.prototype.triggerEvent = function(company) {
      return this.tracker.send(
        'event',
        'Clearbit',
        'Enriched',
        'Clearbit Enriched',
        {nonInteraction: true}
      );
    };

    return Clearbit;

  })();

  providePlugin('Clearbit', Clearbit);

  

  

}).call(this);
