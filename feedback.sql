USE [master]
GO
/****** Object:  Database [FeedBack]    Script Date: 06/29/2020 1:03:25 AM ******/
CREATE DATABASE [FeedBack]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'FeedBack', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.TUTUL\MSSQL\DATA\FeedBack.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'FeedBack_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.TUTUL\MSSQL\DATA\FeedBack_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [FeedBack] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FeedBack].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [FeedBack] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [FeedBack] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [FeedBack] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [FeedBack] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [FeedBack] SET ARITHABORT OFF 
GO
ALTER DATABASE [FeedBack] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [FeedBack] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [FeedBack] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [FeedBack] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [FeedBack] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [FeedBack] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [FeedBack] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [FeedBack] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [FeedBack] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [FeedBack] SET  DISABLE_BROKER 
GO
ALTER DATABASE [FeedBack] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [FeedBack] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [FeedBack] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [FeedBack] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [FeedBack] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [FeedBack] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [FeedBack] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [FeedBack] SET RECOVERY FULL 
GO
ALTER DATABASE [FeedBack] SET  MULTI_USER 
GO
ALTER DATABASE [FeedBack] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [FeedBack] SET DB_CHAINING OFF 
GO
ALTER DATABASE [FeedBack] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [FeedBack] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [FeedBack] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'FeedBack', N'ON'
GO
ALTER DATABASE [FeedBack] SET QUERY_STORE = OFF
GO
USE [FeedBack]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [FeedBack]
GO
/****** Object:  UserDefinedFunction [dbo].[funcGetComment]    Script Date: 06/29/2020 1:03:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select  dbo.funcGetCloudDeployment(880, 'Terminated', 'Error', 18)
CREATE FUNCTION [dbo].[funcGetComment]( @postId int=0,@LogedUserId INT=0)
RETURNS NVARCHAR(MAX)  
AS  
BEGIN
  RETURN (
		SELECT ISNULL(C.CommentId, 0) commentId,
		       ISNULL(C.CommentText, 0) commentText
			  ,ISNULL(C.CreationTime, '') creationTime
			  ,ISNULL(C.cLike, 0) cLike
			  ,ISNULL(C.cDislike, 0) cDislike,
			   ISNULL(C.PostId, 0) postId,
			     ISNULL(C.UserId, 0) userId
				  ,ISNULL(u.UserName, '') userName
				  ,ISNULL(u.UserType, '') userType
				 ,ISNULL((SELECT o.IsLike FROM OpinionLog o WHERE o.CommentId=C.CommentId AND O.UserId=@LogedUserId),0) IsLikedByLoggedUser

		  FROM Comment C
		  LEFT JOIN [User] u ON u.UserId=c.UserId
		  Where C.PostId=@postId 
		 
		  ORDER BY C.CommentId DESC
    FOR JSON AUTO, Include_Null_Values)
END
GO
/****** Object:  Table [dbo].[Comment]    Script Date: 06/29/2020 1:03:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comment](
	[CommentId] [int] IDENTITY(1,1) NOT NULL,
	[CommentText] [nvarchar](max) NULL,
	[PostId] [int] NOT NULL,
	[CreationTime] [datetime] NULL,
	[cLike] [int] NULL,
	[cDislike] [int] NULL,
	[UserId] [int] NULL,
 CONSTRAINT [PK_Comment] PRIMARY KEY CLUSTERED 
(
	[CommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OpinionLog]    Script Date: 06/29/2020 1:03:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpinionLog](
	[OpinionLogId] [int] IDENTITY(1,1) NOT NULL,
	[CommentId] [int] NULL,
	[IsLike] [bit] NULL,
	[UserId] [int] NULL,
 CONSTRAINT [PK_OpinionLog] PRIMARY KEY CLUSTERED 
(
	[OpinionLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Post]    Script Date: 06/29/2020 1:03:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Post](
	[PostId] [int] IDENTITY(1,1) NOT NULL,
	[PostText] [nvarchar](max) NULL,
	[CreationTime] [datetime] NULL,
	[UserId] [int] NULL,
	[imagePath] [nvarchar](200) NULL,
 CONSTRAINT [PK_Post] PRIMARY KEY CLUSTERED 
(
	[PostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PostType]    Script Date: 06/29/2020 1:03:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostType](
	[PostTypeId] [int] IDENTITY(1,1) NOT NULL,
	[PostTypeName] [nvarchar](200) NULL,
	[PostTypeIcon] [nvarchar](100) NULL,
 CONSTRAINT [PK_PostType] PRIMARY KEY CLUSTERED 
(
	[PostTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 06/29/2020 1:03:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](200) NULL,
	[LastName] [nvarchar](200) NULL,
	[UserTypeId] [int] NULL,
	[UserName] [nvarchar](300) NULL,
	[Password] [nvarchar](20) NULL,
	[Email] [nvarchar](50) NULL,
	[Phone] [nvarchar](200) NULL,
	[BirthDate] [datetime] NULL,
	[UserType] [nvarchar](300) NULL,
	[Address] [nvarchar](500) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserType]    Script Date: 06/29/2020 1:03:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserType](
	[UserTypeId] [int] IDENTITY(1,1) NOT NULL,
	[UserTypeName] [nvarchar](200) NULL,
 CONSTRAINT [PK_UserType] PRIMARY KEY CLUSTERED 
(
	[UserTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Comment] ON 

INSERT [dbo].[Comment] ([CommentId], [CommentText], [PostId], [CreationTime], [cLike], [cDislike], [UserId]) VALUES (1, N'Comment 1', 2, CAST(N'2020-05-17T21:04:25.717' AS DateTime), 2, 2, 4)
INSERT [dbo].[Comment] ([CommentId], [CommentText], [PostId], [CreationTime], [cLike], [cDislike], [UserId]) VALUES (2, N'Comment 2', 1, CAST(N'2020-05-17T21:04:35.477' AS DateTime), 1, 1, 4)
SET IDENTITY_INSERT [dbo].[Comment] OFF
SET IDENTITY_INSERT [dbo].[OpinionLog] ON 

INSERT [dbo].[OpinionLog] ([OpinionLogId], [CommentId], [IsLike], [UserId]) VALUES (1, 1, 0, 1)
INSERT [dbo].[OpinionLog] ([OpinionLogId], [CommentId], [IsLike], [UserId]) VALUES (2, 1, 0, 4)
INSERT [dbo].[OpinionLog] ([OpinionLogId], [CommentId], [IsLike], [UserId]) VALUES (3, 1, 1, 2)
INSERT [dbo].[OpinionLog] ([OpinionLogId], [CommentId], [IsLike], [UserId]) VALUES (4, 2, 1, 2)
INSERT [dbo].[OpinionLog] ([OpinionLogId], [CommentId], [IsLike], [UserId]) VALUES (5, 2, 0, 4)
INSERT [dbo].[OpinionLog] ([OpinionLogId], [CommentId], [IsLike], [UserId]) VALUES (6, 1, 1, 7)
SET IDENTITY_INSERT [dbo].[OpinionLog] OFF
SET IDENTITY_INSERT [dbo].[Post] ON 

INSERT [dbo].[Post] ([PostId], [PostText], [CreationTime], [UserId], [imagePath]) VALUES (7, N'test trfhgfhgf fghfghfg ghgfnfhfg ghfgh', CAST(N'1990-05-20T23:50:40.130' AS DateTime), 9, NULL)
INSERT [dbo].[Post] ([PostId], [PostText], [CreationTime], [UserId], [imagePath]) VALUES (8, N'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero''s De Finibus Bonorum et Malorum for use in a type specimen book.', CAST(N'2020-05-21T01:27:46.677' AS DateTime), 9, NULL)
INSERT [dbo].[Post] ([PostId], [PostText], [CreationTime], [UserId], [imagePath]) VALUES (9, N'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero''s De Finibus Bonorum et Malorum for use in a type specimen book.', CAST(N'2020-05-21T01:31:39.130' AS DateTime), 9, NULL)
INSERT [dbo].[Post] ([PostId], [PostText], [CreationTime], [UserId], [imagePath]) VALUES (10, N'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero''s De Finibus Bonorum et Malorum for use in a type specimen book.', CAST(N'2020-05-21T01:33:18.530' AS DateTime), 9, NULL)
INSERT [dbo].[Post] ([PostId], [PostText], [CreationTime], [UserId], [imagePath]) VALUES (11, N'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero''s De Finibus Bonorum et Malorum for use in a type specimen book.', CAST(N'2020-05-21T01:33:49.890' AS DateTime), 9, NULL)
INSERT [dbo].[Post] ([PostId], [PostText], [CreationTime], [UserId], [imagePath]) VALUES (1003, N'Hi', CAST(N'2020-06-28T20:03:42.003' AS DateTime), 9, NULL)
SET IDENTITY_INSERT [dbo].[Post] OFF
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([UserId], [FirstName], [LastName], [UserTypeId], [UserName], [Password], [Email], [Phone], [BirthDate], [UserType], [Address]) VALUES (1, N'User', N'Profile1', 1, N'User1', N'12345', N'demo@gmail.com', N'0123432411', CAST(N'2020-05-18T00:00:00.000' AS DateTime), N'Admin', NULL)
INSERT [dbo].[User] ([UserId], [FirstName], [LastName], [UserTypeId], [UserName], [Password], [Email], [Phone], [BirthDate], [UserType], [Address]) VALUES (2, N'User', N'Profile2', 1, N'User2', N'12345', N'demo2@gmail.com', N'0123432412', CAST(N'2020-05-18T00:00:00.000' AS DateTime), N'Admin', NULL)
INSERT [dbo].[User] ([UserId], [FirstName], [LastName], [UserTypeId], [UserName], [Password], [Email], [Phone], [BirthDate], [UserType], [Address]) VALUES (3, N'User', N'Profile3', 1, N'User3', N'12345', N'demo3@gmail.com', N'0123432413', CAST(N'2020-05-18T00:00:00.000' AS DateTime), N'Admin', NULL)
INSERT [dbo].[User] ([UserId], [FirstName], [LastName], [UserTypeId], [UserName], [Password], [Email], [Phone], [BirthDate], [UserType], [Address]) VALUES (4, N'User', N'Profile4', 1, N'User4', N'12345', N'demo4@gmail.com', N'0123432414', CAST(N'2020-05-18T00:00:00.000' AS DateTime), N'Admin', NULL)
INSERT [dbo].[User] ([UserId], [FirstName], [LastName], [UserTypeId], [UserName], [Password], [Email], [Phone], [BirthDate], [UserType], [Address]) VALUES (5, N'User', N'Profile5', 1, N'User5', N'12345', N'demo5@gmail.com', N'0123432415', CAST(N'2020-05-18T00:00:00.000' AS DateTime), N'Admin', NULL)
INSERT [dbo].[User] ([UserId], [FirstName], [LastName], [UserTypeId], [UserName], [Password], [Email], [Phone], [BirthDate], [UserType], [Address]) VALUES (6, N'User', N'Profile6', 1, N'User6', N'12345', N'demo6@gmail.com', N'0123432416', CAST(N'2020-05-18T00:00:00.000' AS DateTime), N'Admin', NULL)
INSERT [dbo].[User] ([UserId], [FirstName], [LastName], [UserTypeId], [UserName], [Password], [Email], [Phone], [BirthDate], [UserType], [Address]) VALUES (7, N'User', N'Profile7', 1, N'User7', N'12345', N'demo7@gmail.com', N'0123432417', CAST(N'2020-05-18T00:00:00.000' AS DateTime), N'Admin', NULL)
INSERT [dbo].[User] ([UserId], [FirstName], [LastName], [UserTypeId], [UserName], [Password], [Email], [Phone], [BirthDate], [UserType], [Address]) VALUES (9, N'Tutul', N'Chakma', 1, N'tutulcou_9', N'1234', N'tutulcou@gmail.com', N'0191470198', CAST(N'1989-05-02T00:00:00.000' AS DateTime), NULL, N'Motijeel, Dhaka-1216, Bangladesh')
SET IDENTITY_INSERT [dbo].[User] OFF
SET IDENTITY_INSERT [dbo].[UserType] ON 

INSERT [dbo].[UserType] ([UserTypeId], [UserTypeName]) VALUES (1, N'Admin')
INSERT [dbo].[UserType] ([UserTypeId], [UserTypeName]) VALUES (2, N'User')
INSERT [dbo].[UserType] ([UserTypeId], [UserTypeName]) VALUES (3, N'SystemAdmin')
SET IDENTITY_INSERT [dbo].[UserType] OFF
ALTER TABLE [dbo].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_Post] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[Comment] CHECK CONSTRAINT [FK_Comment_Post]
GO
ALTER TABLE [dbo].[Post]  WITH CHECK ADD  CONSTRAINT [FK_Post_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[Post] CHECK CONSTRAINT [FK_Post_User]
GO
/****** Object:  StoredProcedure [dbo].[SpGetPostData]    Script Date: 06/29/2020 1:03:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Tutul Chakma>
-- Create date: <2020-05-14 00:00:00.000,,>
-- Description:	<Description,,>
-- =============================================

--EXEC SpGetPostData  1,50,'',1
CREATE PROCEDURE [dbo].[SpGetPostData]
(		 
	@pageNumber			INT=0
	,@pageSize		    INT=0
	,@search            nvarchar(max)
	,@LogedUserId            INT=0
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	BEGIN TRY
		BEGIN

		DECLARE @Today DateTime, @result nvarchar(MAX), @recordsTotal int=0;
			DECLARE @SkipRow INT=0;
			SET @SkipRow = ((CASE WHEN @pageNumber=0 THEN 1 ELSE @pageNumber END)-1)*@pageSize
			BEGIN
				

				SET @recordsTotal=( SELECT COUNT(p.PostId)FROM [dbo].[POST] p
				WHERE 
				CASE WHEN  ISNULL(p.PostText,'')=''
				           THEN 1
					 WHEN p.PostText LIKE ''+@search+'%' 
					       THEN 1
					 ELSE 0 
				END=1
				)
					
				---=================Paging------------------------------------					 
				SET @result=(ISNULL((
				 SELECT  
				         ISNULL(p.PostId,0) postId,
						 ISNULL(p.[postText],'') postText,
                         ISNULL(p.[creationTime],'') creationTime,	
						 ISNULL(p.UserId,0) userId,
						 ISNULL((select UserName from [User]u WHERE u.UserId=p.UserId),0) userName,
						 ISNULL((select UserType from [User]u WHERE u.UserId=p.UserId),0) userType,
						 ISNULL(JSON_QUERY(dbo.funcGetComment(p.PostId,@LogedUserId)), '[]') AS commentList,
						 ISNULL(@recordsTotal,0) recordsTotal
						
						FROM [dbo].[Post] p
						--where p.PostText LIKE ''+@search+'%'
						WHERE 
						CASE WHEN  ISNULL(p.PostText,'')=''
								   THEN 1
							 WHEN p.PostText LIKE ''+@search+'%' 
								   THEN 1
							 ELSE 0 
						END=1
						
					ORDER BY p.PostId DESC		
				---=================Paging------------------------------------
				OFFSET @SkipRow ROWS FETCH NEXT @pageSize ROWS ONLY
				FOR JSON AUTO, Include_Null_Values),''))
				SELECT @result
			END

		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		DECLARE @ErrorNumber INT = ERROR_NUMBER();
		DECLARE @ErrorLine INT = ERROR_LINE();
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
		DECLARE @ErrorState INT = ERROR_STATE();

	END CATCH
END
GO
USE [master]
GO
ALTER DATABASE [FeedBack] SET  READ_WRITE 
GO
