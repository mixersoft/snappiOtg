'use strict'

###*
 # @ngdoc directive
 # @name snappiOtgApp.directive:snappiDatepicker
 # @description
 # # snappiDatepicker
###
angular.module('snappiOtgApp')
  .directive 'snappiDatepicker', [
    # modified from angular-strap bsDatepicker 
    '$window',
    '$parse',
    '$q',
    '$locale',
    'dateFilter',
    '$datepicker',
    '$dateParser',
    '$timeout',    
    ($window, $parse, $q, $locale, dateFilter, $datepicker, $dateParser, $timeout)->
      defaults = $datepicker.defaults
      isNative =  /(ip(a|o)d|iphone|android)/gi.test($window.navigator.userAgent)
      isNumeric = (n)->
        return !isNaN(parseFloat(n)) && isFinite(n)

      return {
        restrict: 'EAC',
        require: 'ngModel',
        link: (scope, element, attr, controller)->
          # // Directive options
          options = {
            scope: scope,
            controller: controller
          }
          angular.forEach [
              'fromDate'  # model to store fromDate value
              'toDate'    # model to store toDate value
              'placement',
              'container',
              'delay',
              'trigger',
              'keyboard',
              'html',
              'animation',
              'template',
              'autoclose',
              'dateType',
              'dateFormat',
              'modelDateFormat',
              'dayFormat',
              'strictFormat',
              'startWeek',
              'useNative',
              'lang',
              'startView',
              'minView'
            ], (key)-> 
              options[key] = attr[key] if angular.isDefined(attr[key])
          # // Initialize datepicker
          options.dateFormat = 'yyyy-MM-dd' if (isNative && options.useNative)
          options.fromDate = options.fromDate || 'fromDate'
          options.toDate = options.toDate || 'toDate'
          scope.$datepicker = datepicker = $datepicker(element, controller, options);
          options = datepicker.$options;
          # // Observe attributes for changes
          angular.forEach [
              'minDate',
              'maxDate'
            ], (key)-> 
              # // console.warn('attr.$observe(%s)', key, attr[key]);
              angular.isDefined(attr[key]) && attr.$observe(key, (newValue)-> 
                  # // console.warn('attr.$observe(%s)=%o', key, newValue);
                  if (newValue == 'today') 
                    today = new Date();
                    today.setHours(0,0,0,0)
                    datepicker.$options[key] = +new Date(today.getFullYear(), today.getMonth(), today.getDate() + (key == 'maxDate' ? 1 : 0), 0, 0, 0, key == 'minDate' ? 0 : -1);
                  else if (angular.isString(newValue) && newValue.match(/^".+"$/)) 
                    # // Support {{ dateObj }}
                    datepicker.$options[key] = +new Date(newValue.substr(1, newValue.length - 2));
                  else if (isNumeric(newValue)) 
                    datepicker.$options[key] = +new Date(parseInt(newValue, 10));
                  else 
                    datepicker.$options[key] = +new Date(newValue);
                  
                  # // Build only if dirty
                  !isNaN(datepicker.$options[key]) && datepicker.$build(false);
              )
          # // Watch model for changes
          scope.$watch(attr.ngModel, (newValue, oldValue)-> 
              datepicker.update(controller.$dateValue);
            , true)
          dateParser = $dateParser {
              format: options.dateFormat,
              lang: options.lang,
              strict: options.strictFormat
            }
          # // viewValue -> $parsers -> modelValue
          controller.$parsers.unshift (viewValue)-> 
            console.warn('$parser("%s"): viewValue=%o', element.attr('ng-model'), viewValue);
            # // Null values should correctly reset the model value & validity
            if (!viewValue) 
              controller.$setValidity('date', true);
              return;
            parsedDate = dateParser.parse(viewValue, controller.$dateValue);
            if (!parsedDate || isNaN(parsedDate.getTime())) 
              controller.$setValidity('date', false);
              return;
            else 
              isMinValid = isNaN(datepicker.$options.minDate) || parsedDate.getTime() >= datepicker.$options.minDate;
              isMaxValid = isNaN(datepicker.$options.maxDate) || parsedDate.getTime() <= datepicker.$options.maxDate;
              isValid = isMinValid && isMaxValid;
              controller.$setValidity('date', isValid);
              controller.$setValidity('min', isMinValid);
              controller.$setValidity('max', isMaxValid);
              # // Only update the model when we have a valid date
              if (isValid)
                controller.$dateValue = parsedDate;
            if (options.dateType == 'string') 
              return dateFilter(parsedDate, options.modelDateFormat || options.dateFormat);
            else if (options.dateType == 'number') 
              return controller.$dateValue.getTime();
            else if (options.dateType == 'iso') 
              return controller.$dateValue.toISOString();
            else 
              return new Date(controller.$dateValue);
            
          # // modelValue -> $formatters -> viewValue
          controller.$formatters.push (modelValue)->
            # // console.warn('$formatter("%s"): modelValue=%o (%o)', element.attr('ng-model'), modelValue, typeof modelValue);
            if (angular.isUndefined(modelValue) || modelValue == null) 
              date = NaN;
            else if (angular.isDate(modelValue)) 
              date = modelValue;
            else if (options.dateType == 'string') 
              date = dateParser.parse(modelValue, null, options.modelDateFormat);
            else 
              date = new Date(modelValue);
            
            # // Setup default value?
            # // if(isNaN(date.getTime())) 
            # //   today = new Date();
            # //   date = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 0, 0, 0, 0);
            controller.$dateValue = date;
            return controller.$dateValue;
          # // viewValue -> element
          controller.$render = ()->
            # console.warn('$render("%s"): viewValue=%o', element.attr('ng-model'), controller.$viewValue);
            element.val(!controller.$dateValue || isNaN(controller.$dateValue.getTime()) ? '' : dateFilter(controller.$dateValue, options.dateFormat));
          # // Garbage collection
          scope.$on '$destroy', ()-> 
            datepicker.destroy();
            options = null;
            datepicker = null;


          # 
          # overrides
          #
          datepicker.hide = ()->
            # prevent hide()
            # console.log "override hide()"
            return    

          datepicker.select = (date, keep)-> 
            # console.warn('$datepicker.selectdatepicker.$updateSelected ', date, scope.$mode);
            controller.$dateValue = new Date(date);
            controller.$dateValue.setFullYear(date.getFullYear(), date.getMonth(), date.getDate());

            if !controller.$fromDate
              controller.$fromDate = _.clone controller.$dateValue 
            else if controller.$dateValue < controller.$fromDate
              controller.$fromDate = _.clone controller.$dateValue 
              controller.$toDate = null 
            else if controller.$dateValue.getTime() == controller.$fromDate.getTime()
              controller.$fromDate = null 
              controller.$toDate = null  
            else 
              controller.$toDate = _.clone controller.$dateValue 
            # console.log "from="+controller.$fromDate+", to="+controller.$toDate
            # update models for from input 
            parent = element.scope()
            parent[options.fromDate] = controller.$fromDate || ""
            parent[options.toDate] = controller.$toDate || ""

            if (!scope.$mode || keep) 
              controller.$setViewValue(controller.$dateValue);
              controller.$render();
              if (options.autoclose && !keep) 
                datepicker.hide(true);
              
            else 
              angular.extend(viewDate, {
                year: date.getFullYear(),
                month: date.getMonth(),
                date: date.getDate()
              });
              datepicker.setMode(scope.$mode - 1);
              datepicker.$build();

            return 
            

          datepicker.$isSelected = (date)->
            if !controller.$toDate
              return controller.$fromDate && date.getFullYear() == controller.$fromDate.getFullYear() && date.getMonth() == controller.$fromDate.getMonth() && date.getDate() == controller.$fromDate.getDate();
            else 
              return controller.$fromDate <= date && date <= controller.$toDate
            
          datepicker.$updateSelected = ()->
            scope = this.$scope
            for i in [0..scope.rows.length]
              angular.forEach scope.rows[i], (el)->
                el.selected = datepicker.$isSelected(el.date);
                return


            

          datepicker.$promise.then ()->
            # show immediately, do NOT hide
            datepicker.show()
            _build = datepicker.$views[0].build
            datepicker.$views[0].build = ()->
              # update selected after changing months
              _build.apply( datepicker.$views[0], arguments) 
              datepicker.$updateSelected()





      }
  ]
