class Restaurant < Object
	WEEKDAYS = [
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat'
    ]

    # group day with the opening hours
    # [['Mon', '9-17'], ['Tue', '10-15'], ...]
    def initialize(opening_hours)
    	@opening_hours = WEEKDAYS.zip(opening_hours)
    end

    def get_opening_hours
    	# --------------------------
        # -- WRITE YOUR CODE HERE --
        # --------------------------
        grouped_opening_hours = [{ open_hours: @opening_hours[0][1], days: [ WEEKDAYS.index(@opening_hours[0][0]) ] }]
        
        # grouping the day based on opening_hours
        @opening_hours[1..@opening_hours.length-1].each do |opening_hour|
            uniq = true
            grouped_opening_hours.each do |grouped_opening_hour|
                if opening_hour[1] == grouped_opening_hour[:open_hours]
                    grouped_opening_hour[:days].push( WEEKDAYS.index(opening_hour[0]) )
                    uniq = false
                    break
                end
            end

            if uniq
                grouped_opening_hours.push( { open_hours: opening_hour[1], days: [ WEEKDAYS.index(opening_hour[0]) ] } )
            end
        end

        output = []
        grouped_opening_hours.each_with_index do |grouped_opening_hour, idx|
            days = ''

            ## Check if the opening_hours has more than 1 days
            if grouped_opening_hour[:days].length > 1
                ## grouping the index day by sequence
                # ex1: [[0], [4,5,6], [1,2,3]]
                # ex2: [[0, 1,2,3]]
                current_day_idx = grouped_opening_hour[:days][0]
                day_grouping = [[current_day_idx]]

                grouped_opening_hour[:days][1..grouped_opening_hour[:days].length-1].each do |day_idx|
                    if day_idx-1 != current_day_idx
                        day_grouping.push( [day_idx] )
                    else
                        day_grouping[-1].push( day_idx )
                    end

                    current_day_idx = day_idx
                end

                ## days processing to words
                day_arr = []
                day_grouping.each_with_index do |day_idxs, idx|
                    ## use different format for multiply sequence
                    # catch it from the min and max day
                    # do formatting and push it to day_arr
                    if day_idxs.length > 1
                        ## do push with the day range 
                        # ex: Thu - Sat
                        day_arr.push( WEEKDAYS[day_idxs.min] + ' - ' + WEEKDAYS[day_idxs.max] )
                    else
                        ## do push a single day
                        # ex: Sun
                        day_arr.push( WEEKDAYS[day_idxs[0]] )
                    end
                end

                days = day_arr.join(', ')
            else

                days = WEEKDAYS[grouped_opening_hour[:days][0]]
            end
            
            ## OUTPUT FORMAT
            output.push("%{days}: %{open_hours}" % { days: days, open_hours: grouped_opening_hour[:open_hours] })
        end

        print output.join(', ')
    end
end

class OpeningHour < Object

    def initialize(opening_hour, closing_hour)
        @opening_hour = opening_hour
        @closing_hour = closing_hour
    end

    def to_s
        "%{opening_hour}-%{closing_hour}" % {:opening_hour => @opening_hour, :closing_hour => @closing_hour}
    end
end


# Sun: 8-16, Mon: 8-17, Tue: 8-18, Wed: 8-19, Thu: 8-20, Fri: 8-21, Sat: 8-22
restaurant = Restaurant.new([
    OpeningHour.new(8, 16).to_s,  # Sunday
    OpeningHour.new(8, 17).to_s,  # Monday
    OpeningHour.new(8, 18).to_s,  # Tuesday
    OpeningHour.new(8, 19).to_s,  # Wednesday
    OpeningHour.new(8, 20).to_s,  # Thursday
    OpeningHour.new(8, 21).to_s,  # Friday
    OpeningHour.new(8, 22).to_s   # Saturday
])

puts restaurant.get_opening_hours

# Sun, Thu - Sat: 8-16, Mon - Wed: 8-17
restaurant = Restaurant.new([
    OpeningHour.new(8, 16).to_s,  # Sunday
    OpeningHour.new(8, 17).to_s,  # Monday
    OpeningHour.new(8, 17).to_s,  # Tuesday
    OpeningHour.new(8, 17).to_s,  # Wednesday
    OpeningHour.new(8, 16).to_s,  # Thursday
    OpeningHour.new(8, 16).to_s,  # Friday
    OpeningHour.new(8, 16).to_s   # Saturday
])

puts restaurant.get_opening_hours

# Sun - Wed: 8-16, Thu: 8-20, Fri: 8-21, Sat: 8-22
restaurant = Restaurant.new([
    OpeningHour.new(8, 16).to_s,  # Sunday
    OpeningHour.new(8, 16).to_s,  # Monday
    OpeningHour.new(8, 16).to_s,  # Tuesday
    OpeningHour.new(8, 16).to_s,  # Wednesday
    OpeningHour.new(8, 20).to_s,  # Thursday
    OpeningHour.new(8, 21).to_s,  # Friday
    OpeningHour.new(8, 22).to_s   # Saturday
])

puts restaurant.get_opening_hours()
