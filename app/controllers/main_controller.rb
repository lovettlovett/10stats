class MainController < ApplicationController
	include InstagramHelper

	def index
	end

	def new
		render(:new)
	end

	def newbattle
		render(:newbattle)
	end

	def show
		@username = params[:username]
		@insta_user_id = find_insta_user_id(params[:username])
		@profile_stats = profile_stats(@insta_user_id)
		@photos = @profile_stats["media"]
		@followed_by = @profile_stats["followed_by"].to_f
		@follows = @profile_stats["follows"]

		#get basic profile stats – i.e. 
		@profile_attributes = profile_attributes(@insta_user_id)
		@bio = @profile_attributes["bio"]
		@website = @profile_attributes["website"]
		@profile_picture = @profile_attributes["profile_picture"]
		@full_name = @profile_attributes["full_name"]
		@top_tagged = top_tagged(@insta_user_id)
		@total_likes = likes(@insta_user_id)
		@total_comments = comments(@insta_user_id)
		@unique_likers = all_likers(@insta_user_id).uniq.count
		@percentage_of_followers_who_liked = ((@unique_likers)/(@followed_by) * 100).round(2)
		@image_urls = last_10_urls(@insta_user_id)
		@filters = filter(@insta_user_id)
		@type = type(@insta_user_id)
		@top_likers = top_likers(@insta_user_id)
		@timeframe = (timeframe(@insta_user_id)).round(2)
		@number_of_photos = number_of_photos(@insta_user_id).to_f
		@average_comments_photo = ((@total_comments)/@number_of_photos)
		@average_likes_per_photo = ((@total_likes)/@number_of_photos)
		@velocity = (@timeframe/@number_of_photos).round(2)
	end

	def showbattle
		@handle = params[:handle]
		@versus = params[:versus]
		#user_ids
		@handle_user_id = find_insta_user_id(params[:handle])
		@versus_user_id = find_insta_user_id(params[:versus])

		#basic profile_stats
		@handle_stats = profile_stats(@handle_user_id)
		@versus_stats = profile_stats(@versus_user_id)
		@handle_photos = @handle_stats["media"]
		@versus_photos = @versus_stats["media"]
		@handle_followed_by = @handle_stats["followed_by"].to_f
		@versus_followed_by = @versus_stats["followed_by"].to_f
		@handle_follows = @handle_stats["follows"]
		@versus_follows = @versus_stats["follows"]

		#basic profile_attributes
		@handle_profile_attributes = profile_attributes(@handle_user_id)
		@versus_profile_attributes = profile_attributes(@versus_user_id)
		@handle_bio = @handle_profile_attributes["bio"]
		@versus_bio = @versus_profile_attributes["bio"]
		@handle_website = @handle_profile_attributes["website"]
		@versus_website = @versus_profile_attributes["website"]
		@handle_full_name = @handle_profile_attributes["full_name"]
		@versus_full_name = @versus_profile_attributes["full_name"]
		@handle_profile_pic = @handle_profile_attributes["profile_picture"]
		@versus_profile_pic = @versus_profile_attributes["profile_picture"]

		#more advanced stats
		@handle_total_likes = likes(@handle_user_id)
		@versus_total_likes = likes(@versus_user_id)
		#compare:
		if @handle_total_likes > @versus_total_likes 
			@likes_difference = (@handle_total_likes - @versus_total_likes)
			@likes_output = "#{@handle} has #{@likes_difference} more likes than #{@versus}"
		else 
			@likes_difference = (@versus_total_likes - @handle_total_likes)
			@likes_output = "#{@versus} has #{@likes_difference} more likes than #{@handle}"
		end

		@handle_total_comments = comments(@handle_user_id)
		@versus_total_comments = comments(@versus_user_id)
		if @handle_total_comments > @versus_total_comments 
			@comments_difference = (@handle_total_comments - @versus_total_comments)
			@comments_output = "#{@handle} has #{@comments_difference} more comments than #{@versus}"
		else 
			@comments_difference = (@versus_total_comments - @handle_total_comments)
			@comments_output = "#{@versus} has #{@comments_difference} more comments than #{@handle}"
		end


		@handle_number_of_photos = number_of_photos(@handle_user_id).to_f
		@versus_number_of_photos = number_of_photos(@versus_user_id).to_f

		@handle_average_likes_per_photo = ((@handle_total_likes)/@handle_number_of_photos)
		@versus_average_likes_per_photo = ((@versus_total_likes)/@versus_number_of_photos)

		if @handle_average_likes_per_photo > @versus_average_likes_per_photo
			@average_likes_difference = (@handle_average_likes_per_photo - @versus_average_likes_per_photo)
			@average_likes_output = "#{@handle} has #{@average_likes_difference} more average likes per photo than #{@versus}"
		else
			@average_likes_difference = (@versus_average_likes_per_photo - @handle_average_likes_per_photo)
			@average_likes_output = "#{@versus} has #{@average_likes_difference} more average likes per photo than #{@handle}"
		end

		@handle_average_comments_per_photo = ((@handle_total_comments)/@handle_number_of_photos)
		@versus_average_comments_per_photo = ((@versus_total_comments)/@versus_number_of_photos)

		if @handle_average_comments_per_photo > @versus_average_comments_per_photo
			@average_comments_difference = ((@handle_average_comments_per_photo - @versus_average_comments_per_photo)).round(2)
			@average_comments_output = "#{@handle} has #{@average_comments_difference} more average comments per photo than #{@versus}"
		else
			@average_comments_difference = ((@versus_average_comments_per_photo - @handle_average_comments_per_photo)).round(2)
			@average_comments_output = "#{@versus} has #{@average_comments_difference} more average comments per photo than #{@handle}"
		end

		@handle_unique_likers = all_likers(@handle_user_id).uniq.count
		@versus_unique_likers = all_likers(@versus_user_id).uniq.count

		if @handle_unique_likers > @versus_unique_likers
			@unique_likers_difference = (@handle_unique_likers - @versus_unique_likers)
			@unique_likers_output = "#{@handle} has #{@unique_likers_difference} more unique likers than #{@versus}"
		else
			@unique_likers_difference = (@versus_unique_likers - @handle_unique_likers)
			@unique_likers_output = "#{@versus} has #{@unique_likers_difference} more unique likers than #{@handle}"
		end

		@handle_percentage_of_followers_who_liked = ((@handle_unique_likers)/(@handle_followed_by) * 100).round(2)
		@versus_percentage_of_followers_who_liked = ((@versus_unique_likers)/(@versus_followed_by) * 100).round(2)

		if @handle_percentage_of_followers_who_liked > @versus_percentage_of_followers_who_liked
			@percentage_of_followers_difference = ((@handle_percentage_of_followers_who_liked - @versus_percentage_of_followers_who_liked)).round(2)
			@percentage_of_followers_output = "#{@percentage_of_followers_difference}% more of #{@handle}'s followers like their posts"
		else
			@percentage_of_followers_difference = ((@versus_percentage_of_followers_who_liked - @handle_percentage_of_followers_who_liked)).round(2)
			@percentage_of_followers_output = "#{@percentage_of_followers_difference}% more of #{@versus}'s followers like their posts"
		end

		@handle_top_likers = top_likers(@handle_user_id)
		@versus_top_likers = top_likers(@versus_user_id)

		@handle_timeframe = (timeframe(@handle_user_id)).round(2)
		@versus_timeframe = (timeframe(@versus_user_id)).round(2)

		@handle_velocity = (@handle_timeframe/@handle_number_of_photos).round(2)
		@versus_velocity = (@versus_timeframe/@versus_number_of_photos).round(2)

		if @handle_velocity < @versus_velocity
			@velocity_difference = ((@versus_velocity/@handle_velocity)).round(2)
			@velocity_output = "#{@handle} posts #{@velocity_difference}x more frequently than #{@versus}"
		else
			@velocity_difference = ((@handle_velocity/@versus_velocity)).round(2)
			@velocity_output = "#{@versus} posts #{@velocity_difference}x more frequently than #{@handle}"
		end

		@handle_image_urls = last_10_urls(@handle_user_id)
		@versus_image_urls = last_10_urls(@versus_user_id)
	end

end