! Copyright 2005-2013 ECMWF.
!
! This software is licensed under the terms of the Apache Licence Version 2.0
! which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
! 
! In applying this licence, ECMWF does not waive the privileges and immunities granted to it by
! virtue of its status as an intergovernmental organisation nor does it submit to any jurisdiction.
!
!
!  Description:
!  Example on how to use keys_iterator functions and the
!  grib_keys_iterator structure to get all the available
!  keys in a message.
!
!
program keys_iterator
  use grib_api
  implicit none
  integer            :: kiter,ifile,igrib,iret
  character(len=256) :: key
  character(len=256) :: value
  character(len=2048) :: all
  integer            :: len,strlen
  integer            :: grib_count
  len=256

  ifile=5

  call grib_open_file(ifile, &
       '../../data/regular_latlon_surface.grib1','r')

  grib_count=0
  ! Loop on all the messages in a file.

  call grib_new_from_file(ifile,igrib)

  do while (igrib .ne. -1)

  grib_count=grib_count+1
  write(*,'("-- GRIB N.",I4," --")') grib_count

  ! valid name_spaces are ls and mars
  call grib_keys_iterator_new(igrib,kiter,'ls')

  if (kiter .eq. -1) then
    print *, 'invalid key iterator'
  endif

  do

     call grib_keys_iterator_next(kiter, iret)

     if (iret .eq. 0) exit

     call grib_keys_iterator_get_name(kiter,key)

     call grib_get(igrib,key,value)
     all='|'//trim(key)//'|'//' = '//'|'//trim(value)//'|'
     write(*,*) trim(all)

  end do

  call grib_keys_iterator_delete(kiter)
  call grib_release(igrib)
  call grib_new_from_file(ifile,igrib, iret)
  end do


  call grib_close_file(ifile)

end program keys_iterator

