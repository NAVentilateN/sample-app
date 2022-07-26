document.addEventListener("turbo:load", function() {
  document.addEventListener("change", function(event) {
  // find the file uploader element
  // uploading a file is a change in the element therefore the eventlistener, listen for a change
    let image_upload = document.querySelector('#micropost_image');
    // 
    const size_in_megabytes = image_upload.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert("Maximum file size is 5MB. Please choose a smaller file.");
      image_upload.value = "";
    }
  });
});